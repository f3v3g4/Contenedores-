Docker save / load vs export / import / 
===================================

save funciona con imágenes de Docker. Guarda todo lo necesario para construir un contenedor desde cero. Utilice este comando si desea compartir una imagen con otras personas.

load funciona con imágenes de Docker. Utilice este comando si desea ejecutar una imagen exportada con save. A diferencia de pull, que requiere conectarse a un registro de Docker, la carga se puede importar desde cualquier lugar (por ejemplo, un sistema de archivos, URL).

export funciona con contenedores Docker y exporta el filesystem de un contenedor a un archivo.

import funciona con el sistema de archivos de un contenedor exportado y lo importa como una imagen de Docker. Use este comando si tiene un sistema de archivos exportado que desea explorar o usar como capa para una nueva imagen.



Esta es la mejor documentación, clara y contundente::

	$ docker --help | grep -E "(export|import|load|save)"

	  export      Export a container's filesystem as a tar archive
	  import      Import the contents from a tarball to create a filesystem image
	  load        Load an image from a tar archive or STDIN
	  save        Save one or more images to a tar archive (streamed to STDOUT by default)

Creamos un Dockerfile para el ejemplo::

	$ cat Dockerfile
	FROM busybox

	MAINTAINER Carlos Gomez G cgomeznt@gmail.com

	CMD echo $((7*3))

Construimos la imagen docker::

	$ docker build -t "simple-app:1.0" .

Creamos el contenedor::

	$ docker run --name simple-app1.0 simple-app:1.0


Salvamos la imagen con save en un archivo tar::

	$ docker save simple-app:1.0 > simple-app1.0.tar

Cargamos la imagen almacenada en un archivo tar con load::

	$ docker load < simple-app1.0.tar




