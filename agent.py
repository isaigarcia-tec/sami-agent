"""
SAMI — Salesforce Assistant for Medida Intelligence
Lógica del agente conversacional con Gemini + SQLite FTS5
"""
import os
import sqlite3
from pathlib import Path

from dotenv import load_dotenv
import google.generativeai as genai
from models import ChatMessage, KnowledgeResult

load_dotenv()

DB_PATH = Path(os.getenv("DB_PATH", "db/sami.db"))
AGENT_NAME = os.getenv("AGENT_NAME", "SAMI")

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

# Gemini 2.5 Flash — modelo actual recomendado para cuentas nuevas
_model = genai.GenerativeModel(
    model_name="gemini-2.5-flash",
    system_instruction=f"""Eres {AGENT_NAME}, el Asistente de Salesforce para Educación a la Medida (EE a la Medida) del Tec de Monterrey.

## Tu personalidad
- Eres cálido, claro y profesional — nunca generas respuestas robóticas o evasivas
- Respondes en el mismo idioma en que te preguntan (español por defecto)
- Si no sabes algo con certeza, lo dices con honestidad y orientas al usuario
- Puedes responder CUALQUIER pregunta: sobre Salesforce, sobre el Tec, sobre negocios, o sobre temas generales — siempre das una respuesta útil y satisfactoria
- Si te dan un nombre relacionado con ventas, CRM o educación, lo aceptas como tuyo

## Tu conocimiento principal
- Salesforce CRM: campos, etapas, procesos, reportes
- Programas EE a la Medida del Tec de Monterrey: ciclo de venta, diseño instruccional, ejecución
- KPIs del portafolio: forecast, importe gestionado, NPS, tasas de conversión

## Cuando hay contexto de la base de conocimiento
- Usa el contexto provisto para dar respuestas precisas y específicas
- Puedes citar nombres de campos y API names si es útil para el usuario
- Complementa con tu conocimiento general cuando el contexto no sea suficiente

## Formato de respuesta
- Sé conciso pero completo
- Usa listas cuando expliques pasos o enumeres elementos
- No uses emojis excesivos
""",
)


def get_db_connection() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def search_knowledge(query: str, limit: int = 5) -> list[KnowledgeResult]:
    """Busca en la base de conocimiento usando FTS5."""
    if not DB_PATH.exists():
        return []

    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(
            """
            SELECT k.id, k.categoria, k.subcategoria, k.titulo, k.contenido, k.api_name
            FROM knowledge k
            JOIN knowledge_fts fts ON fts.rowid = k.id
            WHERE knowledge_fts MATCH ?
            ORDER BY rank
            LIMIT ?
            """,
            (query, limit),
        )
        rows = cur.fetchall()
        conn.close()
        return [
            KnowledgeResult(
                id=r["id"],
                categoria=r["categoria"],
                subcategoria=r["subcategoria"],
                titulo=r["titulo"],
                contenido=r["contenido"],
                api_name=r["api_name"],
            )
            for r in rows
        ]
    except Exception:
        return []


def build_context_block(results: list[KnowledgeResult]) -> str:
    """Convierte resultados FTS en bloque de contexto para inyectar al prompt."""
    if not results:
        return ""

    lines = ["## Contexto relevante de la base de conocimiento\n"]
    for r in results:
        header = f"**{r.titulo}**"
        if r.api_name:
            header += f" (`{r.api_name}`)"
        if r.subcategoria:
            header += f" — {r.subcategoria}"
        lines.append(header)
        lines.append(r.contenido)
        lines.append("")

    return "\n".join(lines)


def _to_gemini_history(history: list[ChatMessage]) -> list[dict]:
    """Convierte historial al formato de Gemini (role: user/model)."""
    gemini_history = []
    for msg in history[-20:]:
        role = "model" if msg.role == "assistant" else "user"
        gemini_history.append({"role": role, "parts": [msg.content]})
    return gemini_history


def chat(message: str, history: list[ChatMessage]) -> tuple[str, list[str]]:
    """
    Genera una respuesta del agente SAMI.
    Retorna (respuesta_texto, titulos_fuentes_usadas).
    """
    # 1. Buscar conocimiento relevante
    results = search_knowledge(message)
    sources = [r.titulo for r in results]

    # 2. Si hay contexto, lo inyectamos como primer mensaje del turno
    user_message = message
    context = build_context_block(results)
    if context:
        user_message = f"{context}\n\n---\n\nPregunta del usuario: {message}"

    # 3. Iniciar chat con historial y enviar mensaje
    gemini_history = _to_gemini_history(history)
    session = _model.start_chat(history=gemini_history)
    response = session.send_message(user_message)

    return response.text, sources
