"""
SAMI — FastAPI server
Endpoints: /chat, /health, /knowledge (CRUD)
"""
import os
import sqlite3
from pathlib import Path
from contextlib import asynccontextmanager

import json
from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

from models import ChatRequest, ChatResponse, KnowledgeEntry
from agent import chat, get_db_connection

load_dotenv()

DB_PATH = Path(os.getenv("DB_PATH", "db/sami.db"))
SCHEMA_PATH = Path("db/schema.sql")
SEED_PATH = Path("db/seed.sql")


def init_db() -> None:
    """Inicializa SQLite: crea schema y carga seed si la DB no existe."""
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    is_new = not DB_PATH.exists()

    conn = sqlite3.connect(DB_PATH)
    if is_new and SCHEMA_PATH.exists():
        conn.executescript(SCHEMA_PATH.read_text(encoding="utf-8"))
        print("[OK] Schema creado")
    if is_new and SEED_PATH.exists():
        conn.executescript(SEED_PATH.read_text(encoding="utf-8"))
        print("[OK] Seed cargado")
    conn.commit()
    conn.close()


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    print(f"[OK] SAMI listo - DB: {DB_PATH}")
    yield


app = FastAPI(
    title="SAMI — Salesforce Assistant EAM",
    description="Agente conversacional para Educación a la Medida · Tec de Monterrey",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


KANBAN_PATH = Path("../KANBAN.json")


@app.get("/")
def index():
    return FileResponse("chat.html")


@app.get("/kanban")
def kanban():
    return FileResponse("kanban.html")


@app.get("/kanban-data")
def kanban_data():
    if not KANBAN_PATH.exists():
        raise HTTPException(status_code=404, detail="KANBAN.json no encontrado")
    return JSONResponse(json.loads(KANBAN_PATH.read_text(encoding="utf-8")))


@app.get("/health")
def health():
    return {"status": "ok", "agent": os.getenv("AGENT_NAME", "SAMI")}


@app.post("/chat", response_model=ChatResponse)
async def chat_endpoint(req: ChatRequest):
    """Endpoint principal del agente conversacional."""
    if not req.message.strip():
        raise HTTPException(status_code=400, detail="El mensaje no puede estar vacío")

    reply, sources = chat(req.message, req.history)
    return ChatResponse(response=reply, sources=sources)


# ── Knowledge CRUD ────────────────────────────────────────────

@app.get("/knowledge")
def list_knowledge(categoria: str | None = None, q: str | None = None, limit: int = 50):
    """Lista entradas de la base de conocimiento con filtros opcionales."""
    conn = get_db_connection()
    cur = conn.cursor()

    if q:
        cur.execute(
            """
            SELECT k.id, k.categoria, k.subcategoria, k.titulo, k.api_name
            FROM knowledge k
            JOIN knowledge_fts fts ON fts.rowid = k.id
            WHERE knowledge_fts MATCH ?
            ORDER BY rank LIMIT ?
            """,
            (q, limit),
        )
    elif categoria:
        cur.execute(
            "SELECT id, categoria, subcategoria, titulo, api_name FROM knowledge WHERE categoria = ? LIMIT ?",
            (categoria, limit),
        )
    else:
        cur.execute(
            "SELECT id, categoria, subcategoria, titulo, api_name FROM knowledge ORDER BY id LIMIT ?",
            (limit,),
        )

    rows = [dict(r) for r in cur.fetchall()]
    conn.close()
    return {"total": len(rows), "items": rows}


@app.get("/knowledge/{entry_id}")
def get_knowledge(entry_id: int):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM knowledge WHERE id = ?", (entry_id,))
    row = cur.fetchone()
    conn.close()
    if not row:
        raise HTTPException(status_code=404, detail="Entrada no encontrada")
    return dict(row)


@app.post("/knowledge", status_code=201)
def add_knowledge(entry: KnowledgeEntry):
    """Agrega una nueva entrada a la base de conocimiento."""
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO knowledge (categoria, subcategoria, titulo, contenido, api_name, tags) VALUES (?,?,?,?,?,?)",
        (entry.categoria, entry.subcategoria, entry.titulo, entry.contenido, entry.api_name, entry.tags),
    )
    conn.commit()
    new_id = cur.lastrowid
    conn.close()
    return {"id": new_id, "message": "Entrada creada"}


@app.put("/knowledge/{entry_id}")
def update_knowledge(entry_id: int, entry: KnowledgeEntry):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        """UPDATE knowledge SET categoria=?, subcategoria=?, titulo=?, contenido=?, api_name=?, tags=?
           WHERE id=?""",
        (entry.categoria, entry.subcategoria, entry.titulo, entry.contenido, entry.api_name, entry.tags, entry_id),
    )
    if cur.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="Entrada no encontrada")
    conn.commit()
    conn.close()
    return {"message": "Entrada actualizada"}


@app.delete("/knowledge/{entry_id}")
def delete_knowledge(entry_id: int):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("DELETE FROM knowledge WHERE id = ?", (entry_id,))
    if cur.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="Entrada no encontrada")
    conn.commit()
    conn.close()
    return {"message": "Entrada eliminada"}
