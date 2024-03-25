Dokerizar Apache en Centos 7 paso a paso
===============================

Vamos a Dokerizar Apache paso a paso en este laboratorio.

Hacer una imagen de Docker CE con Dockerfile
++++++++++++++++++++++++++++++++++++++++++++

Vamos a crear una imagen con la ayuda del archivo Dockerfile, dentro de él vamos a colocar todas las lineas de instrucciones necesarias para que se descargue una imagen base, luego dentro de ella vamos a copiar algun archivo y/o instaladores que necesitemos para hacer este laboratorio y por ultimo con el comando build procedemos a crear la imagen.

Crear un directorio de trabajo
++++++++++++++++++++++++++++++
::

	$ mkdir laboratorio
	$ cd laboratorio/
	$

Crear el archivo Dockerfile
+++++++++++++++++++++++++++

Vamos a crear un Dockerfile que haga lo siguiente.:

Crear una base de la imagen.

Actualizar la base de la imagen.

Crear el usuario y grupo.

Crear los directorios para demostración.

Crear las variables para demostración.

Crear variable de entorno para demostración.

Copiar los archivos base y de configuración dentro de la imagen.

Asignar los permisos a los directorios creados.

Instalar el Apache.

Iniciar el servicio de Apache con systemctl. Utilizar systemctl tiene unos tips

Crear un volumen que permite modificar, eliminar o agregar archivos y/o directorios luego que el CONTENEDOR este en uso.

Exponer el puerto por donde una aplicación escuchara las peticiones. para demostración.

Así quedaría el archivo Dockerfile y lo copiamos en en directorio laboratorio::

	$ vi Dockerfile
	FROM centos:7

	MAINTAINER Carlos Gomez G cgomeznt@gmail.com

	# Declaramos las siguientes variables por recomendaciones d Docker
	ENV     container docker

	# Instalamos paquetes necesarios para la base que nos permitan administrar y hacer troubleshooting
	RUN     yum -y install sudo \
		httpd.x86_64 \
		net-tools \
		unzip

	RUN	systemctl enable httpd

	# Cuando el CONTENEDOR este operativo, el host expondra este puerto.
	ARG     PORT=80
	EXPOSE  $PORT


Nos aseguramos que estamos en el directorio de trabajo y que están todos los archivos requeridos.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::

	$ pwd
	$ ls
	   Dockerfile  

Creado la imagen con build
+++++++++++++++++++++++++++
::

	$ docker build -t "apache:1.0" --build-arg PORT=80 .

El siguiente comando, si solo si, es en un Virtual Box y es para que tenga la salida de red por el host::

	$ docker build -t "apache:1.0" --build-arg PORT=80 --network host .

Hacer un listado de las imagenes
+++++++++++++++++++++++++++++++++
::

	$ docker images

Crear el contenedor desde la imagen e iniciarlo
++++++++++++++++++++++++++++++++++++++++++++++++
::

	$ docker run -dti --name "apache1.0"  \
	-v /home/laboratorio/html/:/var/www/html \
	-p 1234:80 \
	--privileged "apache:1.0" /usr/sbin/init

Estos argumentos "--privileged "apache:1.0" /usr/sbin/init" es para que funcione el systemctl 

ó::

	$ docker run -dti --name "apache1.0"  \
	--mount type=bind,source=/home/qatest,target=/home/qatest \
	-p 1234:80 \
	--privileged "apache:1.0" /usr/sbin/init

Ahora bien si estas en un Virtual box, agregale el --network host, claro el parametro -p queda deshabilitado. Tomara el que este expuesto en la imagen::


	$ docker run -dti --name "apache1.0"  \
	-v /home/laboratorio/html/:/var/www/html \
	-p 1234:80 \
	--network host \
	--privileged "apache:1.0" /usr/sbin/init


Consultar los contenedores que están iniciados.
+++++++++++++++++++++++++++++++++++++++++++++++
::

	$ docker ps

Ingresar al Contenedor en modo bash
+++++++++++++++++++++++++++++++++++
::

	$ docker exec -i -t apache1.0 /bin/bash
	[oracle@ecde063fb19c /]$ 

Verificamos colocando en un navegador la URL.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Listo podemos abrir un navegador y verificar que ya el Apache este operativo
http://nodo1:1234

Ahora vamos a crear un archivo index para terminar con el laboratorio en el volumen persistente, lo creamos desde nuestro host::

	$ sudo vi /home/laboratorio/html/index.html

	<html>
	  <head>
		<title>www.Docker-Demostracion.com</title>
	  </head>
	  <body>
		<h1>Felicitaciones, esta es un Apache dentro de un Contenedor Docker Demostracion</h1>
	  </body>
	</html>

Volvemos a consultar
http://nodo1:1234


Dokerizar Apache en Alpine paso a paso
===============================

Hacer una imagen de Docker CE con Dockerfile
++++++++++++++++++++++++++++++++++++++++++++

Vamos a crear una imagen con la ayuda del archivo Dockerfile, dentro de él vamos a colocar todas las lineas de instrucciones necesarias para que se descargue una imagen base, luego dentro de ella vamos a copiar algun archivo y/o instaladores que necesitemos para hacer este laboratorio y por ultimo con el comando build procedemos a crear la imagen.

Crear un directorio de trabajo
++++++++++++++++++++++++++++++
::

	$ mkdir laboratorio
	$ cd laboratorio/
	$

Crear el archivo Dockerfile
+++++++++++++++++++++++++++

Vamos a crear un Dockerfile que haga lo siguiente.:

Crear una base de la imagen.

Actualizar la base de la imagen.

Crear el usuario y grupo.

Crear los directorios para demostración.

Crear las variables para demostración.

Crear variable de entorno para demostración.

Copiar los archivos base y de configuración dentro de la imagen.

Asignar los permisos a los directorios creados.

Instalar el Apache.

Iniciar el servicio de Apache con systemctl. Utilizar systemctl tiene unos tips

Crear un volumen que permite modificar, eliminar o agregar archivos y/o directorios luego que el CONTENEDOR este en uso.

Exponer el puerto por donde una aplicación escuchara las peticiones. para demostración.

Así quedaría el archivo Dockerfile y lo copiamos en en directorio laboratorio::

	$ vi Dockerfile
	FROM alpine

	MAINTAINER Carlos Gomez G cgomeznt@gmail.com

	# Declaramos las siguientes variables por recomendaciones d Docker
	ENV     container docker

	# Instalamos paquetes necesarios para la base que nos permitan administrar y hacer troubleshooting
	RUN	mkdir -p /run/apache2 
	RUN	apk add openrc --no-cache
	RUN	apk add apache2 --no-cache
	RUN	apk add openrc --no-cache
	ENTRYPOINT exec /usr/sbin/httpd -D FOREGROUND
	# RUN	rc-service apache2 start

	# Exponemos el puerto 80 en el contenedor
	EXPOSE 80



Nos aseguramos que estamos en el directorio de trabajo y que están todos los archivos requeridos.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::

	$ pwd
	$ ls
	   Dockerfile  

Creado la imagen con build
+++++++++++++++++++++++++++
::

	$ docker build -t "alpine-apache:1.0" .


Hacer un listado de las imagenes
+++++++++++++++++++++++++++++++++
::

	$ docker images

Crear el contenedor desde la imagen e iniciarlo
++++++++++++++++++++++++++++++++++++++++++++++++
::

	$ docker run -dti \
	--name alpine-apache1.0 \
	-v /home/cgomeznt/laboratorio/html:/var/www/localhost/htdocs \
	-p 8080:80 \
	alpine-apache:1.0


Consultar los contenedores que están iniciados.
+++++++++++++++++++++++++++++++++++++++++++++++
::

	$ docker ps

Ingresar al Contenedor en modo bash
+++++++++++++++++++++++++++++++++++
::

	$ docker exec -i -t alpine-apache1.0 /bin/sh
	[]#

Verificamos colocando en un navegador la URL.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Ahora vamos a crear un archivo index para terminar con el laboratorio en el volumen persistente, lo creamos desde nuestro host::

	$ sudo vi /home/cgomeznt/laboratorio/htmlindex.html

	<html>
	  <head>
		<title>www.Docker-Demostracion.com</title>
	  </head>
	  <body>
		<h1>Felicitaciones, esta es un Apache dentro de un Contenedor Docker Demostracion</h1>
	  </body>
	</html>

Volvemos a consultar
http://nodo1:8080



Listo ahora algunos comando de utilidad.

Detener el Contenedores
++++++++++++++++++++++++	
::

	$ docker stop apache1.0

Listar los Contenedores que no estan iniciados
++++++++++++++++++++++++++++++++++++++++++++++++
::

	$ docker ps -a

Iniciar el Contenedores
+++++++++++++++++++++++++++
::

	$ docker start apache1.0

Inspeccionar las configuraciones del Contenedores
+++++++++++++++++++++++++++++++++++++++++++++++++
::

	$  docker container inspect apache1.0

Ver el consumo de recursos del Contenedor
++++++++++++++++++++++++++++

	$ docker stats

Borrar un Contenedores
++++++++++++++++++++++
::

	$ docker stop apache1.0 && docker rm apache1.0

Borrar una Imagen
++++++++++++++++++++
::

	$ docker rmi fd40a4b4601f


Borrar Volumen huérfanos
+++++++++++++++++++++++++
::

	$ docker volume rm $(docker volume ls -qf dangling=true)





