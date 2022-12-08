""" from pydantic import BaseModel
from typing import Optional
from typing import Union
    

class peliculaConsulta1(BaseModel):
    ano: int
    plataforma: str
    tipo: str
    
    class config:
     orn_mode = True


class UserRequestModel(BaseModel):
    ano: int
    plataforma: str

 """