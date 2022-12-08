CREATE DATABASE ProyectoInd;
USE ProyectoInd;

-- La creación de tabla e ingesta de datos se realiza desde el script de Python. 
-- En este script haremos las modificaciones necesarias para la normalización de la base de datos.

-- Eliminación de columnas
-- Eliminaremos las siguientes columnas: index y show_id, ya que he creado la columna indice que cumple el mismo rol.

ALTER TABLE pelicula DROP COLUMN show_id;
ALTER TABLE `proyectoind`.`pelicula` DROP COLUMN `index`,
DROP INDEX `ix_pelicula_index`;


-- Cambio de nombres
-- Cambiaré los nombres de las columnas para hacerlas más intuitivas y acordes al español; además de que algunas utilizan palabras reservadas
/*
ALTER TABLE `proyectoind`.`pelicula` 
CHANGE COLUMN `type` `tipo` VARCHAR(10) NULL DEFAULT NULL ;

ALTER TABLE pelicula
CHANGE COLUMN title titulo VARCHAR(250);

ALTER TABLE pelicula
CHANGE COLUMN director director TEXT;

ALTER TABLE pelicula
CHANGE COLUMN cast elenco TEXT;

ALTER TABLE pelicula
CHANGE COLUMN country pais VARCHAR(250);

ALTER TABLE pelicula
CHANGE COLUMN date_added fecha TEXT; #Esta columna quedará en debate si será dropeada o transformada en una columna con formato DATE

ALTER TABLE pelicula
CHANGE COLUMN release_year ano_lanzamiento INT;

ALTER TABLE pelicula
CHANGE COLUMN rating clasif TEXT;

ALTER TABLE pelicula
CHANGE COLUMN duration duracion TEXT;

ALTER TABLE pelicula
CHANGE COLUMN listed_in listado_en  TEXT;

ALTER TABLE pelicula
CHANGE COLUMN description descripcion TEXT;

 
 */

-- Limpieza de NULOS
-- En este caso los nulos serán reemplazados con SIN DATOS puesto que como se observó en el script de ipynb hay una enorme cantidad de filas con 
-- nulos, hay un 73,3% de registros con al menos un nulo. 
-- Las columnas que las poseen son: director, elenco, pais, fecha, clasif, duracion.
/*
UPDATE pelicula SET director = 'Sin Datos' WHERE director IS NULL;
UPDATE pelicula SET elenco = 'Sin Datos' WHERE elenco IS NULL;
UPDATE pelicula SET pais = 'Sin Datos' WHERE pais IS NULL;
UPDATE pelicula SET fecha = 'Sin Datos' WHERE fecha IS NULL;
UPDATE pelicula SET clasif = 'Sin Datos' WHERE clasif IS NULL;
UPDATE pelicula SET duracion = 'Sin Datos' WHERE duracion IS NULL;
*/

-- Normalización de datos
-- Correré un DISTINCT en las distintas columnas de elementos únicos para verificar que los datos están normalizados.
-- Realizarlo sobre columnas con muchos elementos como elenco exige una previa normalización de datos.

SELECT DISTINCT tipo FROM pelicula;
SELECT DISTINCT titulo FROM pelicula;
SELECT DISTINCT pais FROM pelicula;
SELECT DISTINCT ano_lanzamiento FROM pelicula;
SELECT DISTINCT clasif FROM pelicula;
SELECT DISTINCT duracion FROM pelicula;
SELECT DISTINCT listado_en FROM pelicula;

-- De lo observado y con lo requerido por la actividad en las consultas procederé a borrar las siguientes columnas: pais, descripcion, fecha, clasif
-- Ninguna es necesaria para la realización de consultas y poseen demasiados datos mal ingresados que requieren un trabajo más arduo.
-- Para no perder los datos de forma definitiva en caso de ser necesario su posterior uso, se realizará una copia en otra tabla.
DROP TABLE backup_peli;
CREATE TABLE IF NOT EXISTS backup_peli LIKE pelicula;
INSERT INTO backup_peli SELECT * FROM pelicula;
ALTER TABLE backup_peli DROP COLUMN tipo;
ALTER TABLE backup_peli DROP COLUMN idPlataforma;
ALTER TABLE backup_peli DROP COLUMN titulo;
ALTER TABLE backup_peli DROP COLUMN director;
ALTER TABLE backup_peli DROP COLUMN elenco;
ALTER TABLE backup_peli DROP COLUMN ano_lanzamiento;
ALTER TABLE backup_peli DROP COLUMN duracion;
ALTER TABLE backup_peli DROP COLUMN listado_en;

ALTER TABLE pelicula DROP COLUMN pais;
ALTER TABLE pelicula DROP COLUMN fecha;
ALTER TABLE pelicula DROP COLUMN clasif;
ALTER TABLE pelicula DROP COLUMN descripcion;

-- Nuevas columnas
-- Para organizar mejor, se generará una columna id_pelicula y separaremos el tipo de plataforma,
-- una columna de min_s para determinar si se trata de min o temporadas.

ALTER TABLE pelicula
ADD COLUMN plataforma VARCHAR(10) DEFAULT 0;


UPDATE pelicula
SET plataforma = CASE
WHEN idPlataforma LIKE '%AMZN%' THEN 'AMZN'
WHEN idPlataforma LIKE '%DSNY%' THEN 'DSNY'
WHEN idPlataforma LIKE '%NETF%' THEN 'NETF'
ELSE 'HULU'
END;

-- Eliminamos min, Season, Seasons y s de la columna duracion
-- Paso un DISTINCT para seguir normalizando y pasar la columna a dato tipo INT

UPDATE pelicula
SET duracion = (SELECT REPLACE(duracion, 's', ''));
UPDATE pelicula
SET duracion = (SELECT REPLACE(duracion, ' s', ''));
UPDATE pelicula
SET duracion = (SELECT REPLACE(duracion, ' min', ''));
UPDATE pelicula
SET duracion = (SELECT REPLACE(duracion, 'Seaon', ''));

-- Observo a profundidad los nulos de la columna duración y comparo brevemente si es posible conseguir el dato en caso de que el mismo
-- se encuentre disponible en una misma pelicula pero distinta plataforma.
SELECT DISTINCT duracion FROM pelicula;
SELECT * FROM pelicula WHERE duracion = 'Sin Dato' and tipo = 'TV Show';
SELECT * FROM pelicula WHERE titulo = 'Louis C.K.: Live at the Comedy Store';
SELECT * FROM pelicula WHERE duracion = 1 AND tipo = 'Movie';
-- Dada la cantidad de 'Sin Datos' existentes (482) y al tiempo que requiere el trabajo, no se procederá a comparar las peliculas entre plataformas
-- Procedo a cambiar los 'Sin Datos' a 1 en movies , esto para luego pasar la columna a INT y colocar en su lugar el promedio
-- de la columna según el tipo de emisión.
SELECT DISTINCT duracion FROM pelicula WHERE tipo = 'TV Show';
SELECT DISTINCT duracion FROM pelicula WHERE tipo = 'Movie';

UPDATE pelicula SET duracion = 1 WHERE tipo = 'Movie' AND duracion = 'Sin Dato';
ALTER TABLE `proyectoind`.`pelicula` CHANGE COLUMN `duracion` `duracion` INT NULL DEFAULT NULL ;

SELECT round(AVG(duracion),0) FROM pelicula WHERE  tipo = 'Movie';
UPDATE pelicula SET duracion = 91  WHERE tipo = 'Movie' AND duracion = 1;

-- Borramos las columnas que quedaron redundantes, estas son idPlataforma (pues ya tenemos la columna id_pelicula y plataforma)

ALTER TABLE pelicula DROP COLUMN idPlataforma;

-- Elenco
-- Desde el script Limpieza.ipynb se crea una tabla con los actores que aparecen por pelicula asignandoles un n° que debe ser igual 
-- al indice de la pelicula al que pertenecen y que se encuentra en la tabla pelicula.ALTER
-- Solo borramos la columna index ya que contamos con indice que posee los mismos datos

ALTER TABLE `proyectoind`.`actor` DROP COLUMN `index`,
DROP INDEX `ix_actor_index`;

-- Borramos los espacios en blanco que hay en la columna actor

UPDATE actor SET nombre = (SELECT TRIM(nombre));

-- Genero
-- Procedemos a realizar lo mismo con la tabla genero

ALTER TABLE `proyectoind`.`genero` DROP COLUMN `index`,
DROP INDEX `ix_genero_index`;

UPDATE genero SET genero = (SELECT TRIM(genero));

-- Dada la adición de las dos tablas realizado desde el script limpieza.ipynb, las columnas elenco y listado_en no tienen sentido,
-- se procede a borrarlas

ALTER TABLE pelicula DROP COLUMN listado_en ;
ALTER TABLE pelicula DROP COLUMN elenco ;