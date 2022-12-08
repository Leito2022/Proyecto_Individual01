# Proyecto_Individual01
 Autor: Rodríguez Jorge Leonardo
 Tema: Proyecto - Data Engineer
 
 El presente proyecto tiene como objetivo realizar la subida de datos a partir de archivos, su tratamiento y limpieza y la puesta de ellos para la generación de ciertas consultas específicas, luego dichas consultas deben poder realizarse desde un entorno externo usando fastAPI y finalizado esto, debe poder conteneizarse con Docker listo para su exportación.
 
  Los Pasos a seguir entonces serán:
  1. Suba de archivos
  2. Limpieza
  3. Consultas
  4. FastApi
  5. Docker
  6. Presentación Final
 
1. Suba de archivos

 La suba de archivos se realiza en el archivo Suba.ipynb que se encuentra en la carpeta ETL, allí se explica con detalle la suba de los datos. En lineas generales, se creó un indice para cada tabla etiquetando el tipo de plataforma que usa. Luego se concatena todas las columnas y se crea un indice nuevo. A partir de allí se exporta la tabla creada a MySQL para mayor tratamiento.
 
2. Limpieza

 La limpieza se realiza principalmente en MySQL, en el archivo limpieza.sql, allí se explica con detalle los pasos realizados para la limpieza, los que incluye normalizar datos, eliminación de columnas, creación de un backup, modificación de los tipos de datos, tratamiento de NA, entre otros. 
 
  Cabe aclarar que la limpieza se realizó con el objetivo de realizar las consultas solicitadas para el proyecto, es posible realizar un tratamiento aún más profundo pero que por cuestiones de tiempo debieron ser omitidas, pues debemos aprender a usar FastAPI y Docker para este trabajo.
  
3. Consultas

 Las consultas fueron ejecutadas primero en MySQL, se encuentra en la carpeta ETL llamado consulta.sql, se pueden ejecutar y devolveran los valores solicitados. Esto se realizó a los fines de tener mayor facilidad de trasladar la consulta al entorno de fastAPI.
 
4. FastAPI (ADVERTENCIA)

 En el archivo main.py encontraremos la importación de la librería fastAPI junto con la variable que lo ejecuta. Funciona correctamente y es posible mandarle los gets solicitados.

 Debido a los constantes errores no fue posible crear una estructura más ordenada. La idea original era crear con sqlalchemist el ecosistema necesario para las consultas, esto es crear el route, el database, el model y los schemas. Pero por alguna razón, era constante el error donde al ejecutar uvicorn no detectaba las routers creados ni tampoco se detectaba los imports entre archivos a pesar de que a nivel script si se detectaban (Por ejemplo: al ejecutar una conexion en main.py importando la variable desde el archivo database.py traía un error de que no se encontraba el modulo database a pesar de que la sintaxis era correcta).
 Es por ello que para sortear este problema, tanto los parametros como las querys debieron realizarse en el main y usando pymysql para su gestión.

5. Docker

 A pesar de ser dos simples pasos generan diferentes complicaciones a la hora de generar una imagen, en principio se generaba bien pero luego al querer eliminar y reconstruir la imagen ya no se creaba por razones que desconozco. Otro de los problemas es modificar los puertos para que el cliente pueda usar la base de datos (ya que de por sí no cuenta con dicha base en su sistema local).
 
6. Presentación Final

 Puedes observar todo el proceso que realicé en el siguiente video:
 
 XXXX:...com
 
 
