from fastapi import APIRouter

from schema import peliculaConsulta1

user = APIRouter()

#consulta n° 1
@user.get("/consulta1")
def consulta1(parametros: peliculaConsulta1):
    return {"message":f"probando {peliculaConsulta1}"}

#Para agregar nuevos registros
@user.post("/api/users")
def create_registro(data_registro):
    pass