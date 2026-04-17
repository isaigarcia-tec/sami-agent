# BITÁCORA — SAMI · Salesforce Assistant EAM
**Proyecto:** `agente_sf_eam`  
**Propósito:** Agente conversacional para Salesforce EE a la Medida · Tec de Monterrey

---

## PUERTO CANÓNICO: 8001
Este proyecto usa **exclusivamente** el puerto 8001. Ver mapa global en `C:\tecmty\BITACORA.md`.
Antes de arrancar: `netstat -ano | grep :8001` — si está ocupado, matar el PID con `taskkill //F //PID <pid>`.

---

## ARRANQUE RÁPIDO

```bash
# 1. Crear entorno e instalar dependencias
cd C:\tecmty\agente_sf_eam
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt

# 2. Configurar API Key
copy .env.example .env
# Editar .env y poner ANTHROPIC_API_KEY=sk-ant-...

# 3. Arrancar servidor (la DB se crea automáticamente en el primer arranque)
uvicorn main:app --reload --port 8001

# → Swagger UI: http://localhost:8001/docs
# → Chat: POST http://localhost:8001/chat
# → Health: GET http://localhost:8001/health
```

---

## 2026-04-13 — Sesión inaugural · Construcción del proyecto

**Sabio:** Yin-03 Arquitectura

### Archivos creados
| Archivo | Descripción |
|---|---|
| `main.py` | FastAPI app: `/chat`, `/health`, `/knowledge` CRUD |
| `agent.py` | Lógica Claude + FTS5 knowledge retrieval |
| `models.py` | Pydantic models: ChatRequest, ChatResponse, KnowledgeEntry |
| `db/schema.sql` | SQLite con FTS5 virtual table + triggers de sincronización |
| `db/seed.sql` | 40+ entradas: 89 campos Salesforce + procesos + FAQs |
| `requirements.txt` | fastapi, uvicorn, anthropic, python-dotenv, pydantic |
| `.env.example` | Plantilla de variables de entorno |

### Decisiones de arquitectura
- **SQLite FTS5** (no vector DB): conocimiento estático, sin infraestructura extra, queries en µs
- **Sin autenticación**: consumido desde el portal Tec (TecGPT) — auth delegada al portal
- **Sin integraciones externas** por ahora: el usuario alimenta la KB manualmente vía `/knowledge` POST
- **Claude Opus 4.6** como LLM principal (puede cambiarse a Haiku para menor costo)

### Base de conocimiento inicial (seed)
- Tab Información Básica: 12 campos
- Tab EE a la Medida: 12 campos  
- Tab Datos del Programa: 10 campos
- Tab Ejecución: 10 campos
- Tab Colaboradores: 7 campos
- Procesos: ciclo de venta, facturación, KPIs
- FAQs: crear oportunidad, campos obligatorios, forecast
- Agente: auto-descripción de SAMI

### Estado al 2026-04-13 (fin de sesión inaugural)
- Servidor: ARRANCADO en puerto 8001 (`uvicorn main:app --port 8001`)
- DB: `db/sami.db` creada con schema FTS5 + 51 entradas seed
- API Gemini: KEY configurada pero proyecto GCP 734920551766 tiene cuota free tier = 0

### Credenciales registradas
| Campo | Valor |
|---|---|
| API Key | `AIzaSyCz3xWXgFV-zEu4EVafH65Mno-T4Gx5ico` |
| Nombre de la key | SAMI |
| Proyecto GCP | `projects/734920551766` |
| Número de proyecto | `734920551766` |
| Archivo | `c:\tecmty\agente_sf_eam\.env` ← ya configurada |

### Problema API Key — PENDIENTE CRÍTICO
El proyecto GCP `734920551766` tiene cuota free tier = 0 para todos los modelos Gemini (verificado: gemini-2.0-flash, gemini-2.0-flash-lite). El código y servidor están correctos — es un problema de configuración de cuotas en el proyecto Google Cloud.

**Diagnóstico:** La key fue creada en Google Cloud Console (no desde AI Studio), lo que no genera automáticamente las cuotas free tier.

**Solución:** Ir a `aistudio.google.com/apikey` → "Create API key" → seleccionar **"Create in new project"** → reemplazar la key en `.env`. La nueva key tendrá free tier automático (15 RPM, 1500 req/día).

### Pendientes
| # | Tarea | Responsable | Prioridad |
|---|---|---|---|
| 1 | Obtener nueva API key desde AI Studio en proyecto NUEVO | Gato | **CRÍTICA** |
| 2 | Actualizar `.env` con nueva key | Asistente (en cuanto Gato la comparta) | Alta |
| 3 | Completar seed con campos faltantes del HTML | Gato → via POST `/knowledge` | Media |
| 4 | Integrar con TecGPT portal (iframe o API call) | Pendiente de definir | Futura |
| 5 | Agregar streaming SSE al `/chat` endpoint | Asistente | Futura |
| 6 | Frontend propio (si aplica) | Asistente | Futura |

---
