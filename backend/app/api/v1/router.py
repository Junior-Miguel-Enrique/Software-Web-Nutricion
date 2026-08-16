from fastapi import APIRouter
from app.api.v1.endpoints import users  # Importaremos los módulos aquí

api_router = APIRouter()

# Incluir los diferentes módulos de la API
api_router.include_router(users.router, prefix="/users", tags=["users"])
# api_router.include_router(ia.router, prefix="/ia", tags=["ia"])