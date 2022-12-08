USE proyectoind;

-- Una vez limpia la tabla, procederé a generar las consultas que requiere la actividad

-- Máxima duración según tipo de film (película/serie),
-- por plataforma y por año: El request debe ser: get_max_duration(año, plataforma, [min o season])

-- PARAMETROS: AÑO, PLATAFORMA, TIPO (MOVIE = min, TV Show = Season)
SELECT  titulo FROM pelicula
WHERE ano_lanzamiento = 2018 AND plataforma = 'HULU' AND tipo = 'Movie'
ORDER BY duracion DESC
LIMIT 1; 

-- Cantidad de películas y series (separado) por plataforma El request debe ser: get_count_plataform(plataforma)
SELECT plataforma, COUNT(titulo), tipo FROM pelicula
WHERE plataforma = 'NETF'
GROUP BY tipo;

-- Cantidad de veces que se repite un género y plataforma con mayor frecuencia del mismo. El request debe ser: get_listedin('genero')
SELECT p.plataforma, COUNT(g.genero) FROM pelicula p
INNER JOIN genero g ON g.indice = p.indice
WHERE g.genero = 'Comedy' 
GROUP BY p.plataforma
LIMIT 1; 

-- Actor que más se repite según plataforma y año. El request debe ser: get_actor(plataforma, año)
SELECT p.plataforma, p.ano_lanzamiento, count(a.nombre) as cantidad, nombre FROM pelicula p
INNER JOIN actor a ON a.indice = p.indice
WHERE p.plataforma = 'NETF' AND ano_lanzamiento = 2018
GROUP BY a.nombre
ORDER BY count(a.nombre) DESC
LIMIT 1;

