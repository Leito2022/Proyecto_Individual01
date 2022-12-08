""" from sqlalchemy.orm import Session

from . import models, schema


def get_pelicula(db: Session, pelicula_id: int):
    return db.query(models.Pelicula).filter(models.Pelicula.id_pelicula == pelicula_id).first()

# def create_pelicula(db: Session, user: schemas.PeliculaCreate):
#   return db_user """

