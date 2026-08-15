# Sistema Web y Móvil de Nutrición

Monorepo del sistema integral de gestión nutricional, compuesto por una API backend (FastAPI), panel web de administración (Angular) y aplicación móvil para pacientes (Flutter).

## Arquitectura del Proyecto

- **`backend/`**: API REST en Python (FastAPI + SQLAlchemy + PostgreSQL/Neon DB).
- **`frontend-web/`**: Panel administrativo para nutricionistas (Angular).
- **`app_mobile/`**: Aplicación móvil para seguimiento de pacientes (Flutter).
- **`database/`**: Scripts de inicialización SQL y contenedores Docker.

---

## Requisitos Previos

- **Node.js** v18+ y **Angular CLI** (`npm i -g @angular/cli`)
- **Python** 3.10+
- **Flutter SDK**
- **Docker** & **Docker Compose** (opcional para BD local)

---

## Guía de Inicio Rápido

### 1. Backend (FastAPI)
```bash
cd backend
python -m venv venv
# En Windows:
venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload