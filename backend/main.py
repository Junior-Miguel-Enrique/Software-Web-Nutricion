import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(
    title="API Nutrición Web & Móvil",
    version="1.0.0"
)

# Permitir conexiones desde Angular y Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DATABASE_URL = os.getenv("DATABASE_URL")

# Neon requiere cambiar 'postgresql://' a 'postgresql+psycopg2://' si SQLAlchemy lo requiere
if DATABASE_URL and DATABASE_URL.startswith("postgresql://"):
    DATABASE_URL = DATABASE_URL.replace("postgresql://", "postgresql+psycopg2://", 1)

engine = create_engine(DATABASE_URL) if DATABASE_URL else None

@app.get("/")
def read_root():
    return {"status": "ok", "message": "API de Nutrición funcionando en la nube 🚀"}

@app.get("/health")
def db_health():
    if not engine:
        return {"db_status": "error", "message": "No hay DATABASE_URL configurada"}
    try:
        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))
            return {"db_status": "connected", "neon_response": result.fetchone()[0]}
    except Exception as e:
        return {"db_status": "disconnected", "error": str(e)}