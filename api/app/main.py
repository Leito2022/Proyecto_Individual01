from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from typing import Union

import pymysql


#Realizamos la conexion a la base de datos
conexion = pymysql.connect(host= "localhost",
                        port= 3306,
                        user = "root",
                        passwd= "admin",
                        db = "proyectoind")

cursor = conexion.cursor()


app = FastAPI()

""" @app.on_event("startup")
def startup():
    if conexion.closed():
      conexion.connect()

@app.on_event("shutdown")
def shutdown():
  if not conexion.closed():
    conexion.close() """
    
#Creo la consulta n° 1 
@app.get("/get_max_duration/")
def consulta1(plataforma: str, ano: int, tipo: str):
  plat = plataforma
  año = ano
  tipo = tipo

  cursor.execute(f"""SELECT  titulo FROM pelicula
                WHERE ano_lanzamiento = {año} AND plataforma = '{plat}' AND tipo = '{tipo}'
                ORDER BY duracion DESC
                LIMIT 1; 
                """)

  respuesta = cursor.fetchall()[0][0]
  respuesta2= f"probando, plataforma es: {plataforma}, el año es: {ano} y el tipo {tipo}/n La respuesta es: {respuesta}"

  return {"respuesta": respuesta}

#Creo la consulta n° 2
@app.get("/get_count_plataform/")
def consulta2(plataforma: str):
  plat1 = plataforma

  cursor.execute(f"""
                SELECT plataforma, COUNT(titulo), tipo FROM pelicula
                WHERE plataforma = '{plat1}'
                GROUP BY tipo;
                """)

  respuesta = cursor.fetchall()

  return {"respuesta": respuesta}

#Creo la consulta n° 3

@app.get("/get_listedin/")
def consulta3(genero: str):
  genero = genero

  cursor.execute(f"""
                SELECT p.plataforma, COUNT(g.genero) Cantidad FROM pelicula p
                INNER JOIN genero g ON g.indice = p.indice
                WHERE g.genero = '{genero}' 
                GROUP BY p.plataforma
                ORDER BY Cantidad DESC
                LIMIT 1; 
                """)

  respuesta = cursor.fetchall()

  return {"respuesta": respuesta}


#Creo la consulta n° 4
@app.get("/get_actor/")
def consulta4(plataforma: str, año: int):
  plat = plataforma
  ano = año

  cursor.execute(f"""
               SELECT p.plataforma, p.ano_lanzamiento, count(a.nombre) as cantidad, nombre FROM pelicula p
               INNER JOIN actor a ON a.indice = p.indice
               WHERE p.plataforma = '{plat}' AND ano_lanzamiento = {ano}
               GROUP BY a.nombre
               ORDER BY count(a.nombre) DESC
               LIMIT 1; 
                """)

  respuesta = cursor.fetchall()

  return {"respuesta": respuesta}


