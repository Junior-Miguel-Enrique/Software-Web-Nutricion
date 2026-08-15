import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# Cargar variables de entorno desde el .env
load_dotenv()

# Obtener URL de la base de datos (PostgreSQL / Neon)
DATABASE_URL = os.getenv("DATABASE_URL")

if not DATABASE_URL:
    raise ValueError("⚠️ No se encontró DATABASE_URL en el archivo .env")

# Crear el motor de conexión de SQLAlchemy
engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,  # Verifica que la conexión esté viva antes de cada consulta
)

# Fabrica de sesiones para interactuar con la BD
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Clase base de la que heredarán todos nuestros modelos/tablas
Base = declarative_base()

# Función de inyección de dependencia para FastAPI (Abre y cierra sesión automáticamente)
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()