""" from sqlalchemy import create_engine, MetaData
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import pymysql


SQLALCHEMY_DATABASE_URL = "mysql+pymysql://root:admin@localhost:3306/proyectoind"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

meta_data = MetaData()

conexion = pymysql.connect(host= "localhost",
                        port= 3306,
                        user = "root",
                        passwd= "admin",
                        db = "proyectoind")

cursor = conexion.cursor()
 """