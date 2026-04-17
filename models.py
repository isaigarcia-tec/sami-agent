from pydantic import BaseModel
from typing import Optional


class ChatMessage(BaseModel):
    role: str  # "user" | "assistant"
    content: str


class ChatRequest(BaseModel):
    message: str
    history: list[ChatMessage] = []


class ChatResponse(BaseModel):
    response: str
    sources: list[str] = []  # títulos de entradas de knowledge base usadas


class KnowledgeEntry(BaseModel):
    categoria: str
    subcategoria: Optional[str] = None
    titulo: str
    contenido: str
    api_name: Optional[str] = None
    tags: Optional[str] = None


class KnowledgeResult(BaseModel):
    id: int
    categoria: str
    subcategoria: Optional[str]
    titulo: str
    contenido: str
    api_name: Optional[str]
