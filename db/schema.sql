-- ============================================================
-- SAMI — Salesforce Assistant for Medida Intelligence
-- Base de conocimiento en SQLite con FTS5
-- Proyecto: agente_sf_eam · Tec de Monterrey
-- ============================================================

PRAGMA journal_mode=WAL;
PRAGMA foreign_keys=ON;

-- ── Tabla principal de conocimiento ──────────────────────────
CREATE TABLE IF NOT EXISTS knowledge (
    id           INTEGER  PRIMARY KEY AUTOINCREMENT,
    categoria    TEXT     NOT NULL,
    subcategoria TEXT,
    titulo       TEXT     NOT NULL,
    contenido    TEXT     NOT NULL,
    api_name     TEXT,
    tags         TEXT,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ── FTS5 virtual table (búsqueda de texto completo) ──────────
-- content= hace que FTS refleje la tabla real sin duplicar datos
CREATE VIRTUAL TABLE IF NOT EXISTS knowledge_fts USING fts5(
    titulo,
    contenido,
    tags,
    content='knowledge',
    content_rowid='id',
    tokenize='unicode61 remove_diacritics 1'
);

-- ── Triggers para mantener FTS sincronizado ──────────────────
CREATE TRIGGER IF NOT EXISTS knowledge_ai AFTER INSERT ON knowledge BEGIN
    INSERT INTO knowledge_fts(rowid, titulo, contenido, tags)
    VALUES (new.id, new.titulo, new.contenido, new.tags);
END;

CREATE TRIGGER IF NOT EXISTS knowledge_ad AFTER DELETE ON knowledge BEGIN
    INSERT INTO knowledge_fts(knowledge_fts, rowid, titulo, contenido, tags)
    VALUES ('delete', old.id, old.titulo, old.contenido, old.tags);
END;

CREATE TRIGGER IF NOT EXISTS knowledge_au AFTER UPDATE ON knowledge BEGIN
    INSERT INTO knowledge_fts(knowledge_fts, rowid, titulo, contenido, tags)
    VALUES ('delete', old.id, old.titulo, old.contenido, old.tags);
    INSERT INTO knowledge_fts(rowid, titulo, contenido, tags)
    VALUES (new.id, new.titulo, new.contenido, new.tags);
    UPDATE knowledge SET updated_at = CURRENT_TIMESTAMP WHERE id = new.id;
END;

-- ── Historial de conversaciones (opcional, para analytics) ───
CREATE TABLE IF NOT EXISTS conversations (
    id         INTEGER  PRIMARY KEY AUTOINCREMENT,
    session_id TEXT     NOT NULL,
    role       TEXT     NOT NULL CHECK(role IN ('user','assistant')),
    content    TEXT     NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_conversations_session ON conversations(session_id);
CREATE INDEX IF NOT EXISTS idx_knowledge_categoria ON knowledge(categoria);
