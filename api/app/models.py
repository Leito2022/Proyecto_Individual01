""" from sqlalchemy import Table,Boolean, Column, ForeignKey, Integer, String
from database import engine, meta_data

from sqlalchemy.orm import relationship

from database import Base

#class Pelicula(Base):
#    __tablename__= "pelicula"
#
 #   tipo = Column(String)
 #   titulo = Column(String)
 #   director = Column(String) 
 #   elenco = Column(String) 
 #   ano_lanzamiento = Column(Integer)     
 #   duracion = Column(Integer)  
 #   listado_en = Column(String)
 #   plataforma = Column(String) 
 #   id_pelicula = Column(Integer, primary_key  = True, index = True)


users = Table("pelicula",meta_data,
            Column("tipo", String),
            Column("titulo", String),
            Column("director", String),
            Column("ano_lanzamiento", Integer),
            Column("duracion", Integer),
            Column("indice", Integer, primary_key = True),
            Column("plataforma", String)
            )

meta_data.create_all(engine) """