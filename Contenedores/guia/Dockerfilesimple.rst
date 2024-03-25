Crear una Imagen con Dockerfile
===============================

Vamos a crear una imagen muy simple con Dockerfile en este laboratorio.

Crear un directorio de trabajo
++++++++++++++++++++++++++++++
::

	$ mkdir laboratorio
	$ cd laboratorio/
	[oracle@nodo1 laboratorio]$

Crear el archivo Dockerfile
+++++++++++++++++++++++++++

Creamos un archivo Dockerfile con el siguiente contenido ::

	$ vi Dockerfile
	FROM centos:7

	MAINTAINER Carlos Gomez G cgomeznt@gmail.com

	# Declaramos las siguientes variables por recomendaciones d Docker
	ENV     container docker

	# Instalamos paquetes necesarios para la base que nos permitan administrar y hacer troubleshooting
	RUN     yum -y install sudo \
		unzip

	# Limpiamos los temporales de yum
	RUN     yum clean all

	# Creamos un usuario y grupo valido solo para ver que lo crea
	RUN     groupadd gprueba
	RUN     useradd -g gprueba uprueba

	# Creamos los directorios requeridos para copiar los archivos base, configuraciones y otras segun sea la necesidad. Tambien le otorgamos los permisos.
	RUN     mkdir -p /prueba/software && \
		mkdir -p /prueba1/EAR && \
		mkdir -p /prueba2

	RUN	chown -R uprueba.gprueba /prueba


Creado la imagen con build
+++++++++++++++++++++++++++
::

	$ docker build -t "imagen-demostracion:1.0" .

El siguiente comando, si solo si, es en un Virtual Box y es para que tenga la salida de red por el host::

	$ docker build -t "imagen-demostracion:1.0" --network host .

Hacer un listado de las imagenes
+++++++++++++++++++++++++++++++++
::

	$ docker images

Crear el contenedor desde la imagen e iniciarlo
++++++++++++++++++++++++++++++++++++++++++++++++


Vamos a crear este contenedor::

	$ sudo docker run -dti --name "contenedor-demostracion1" "imagen-demostracion:1.0"

Ahora creamos este otro::

	$ sudo docker run -dti --name "contenedor-demostracion2" --privileged "imagen-demostracion:1.0" /usr/sbin/init

Estos argumentos "--privileged "imagen-demostracion:1.0" /usr/sbin/init" es para que funcione el systemctl 


Consultar los contenedores que están iniciados.
+++++++++++++++++++++++++++++++++++++++++++++++
::

	$ docker ps

Ingresar al Contenedor en modo bash
+++++++++++++++++++++++++++++++++++
::

	$ docker exec -i -t contenedor-demostracion1 /bin/bash
	[root@e3330f11ec2f /]# systemctl 
	Failed to get D-Bus connection: Operation not permitted

Ingresamos al otro contenedor::

	$ sudo docker exec -i -t contenedor-demostracion2 /bin/bash
	[root@ed2792abecd2 /]# systemctl
		[...]


Detener el Contenedores
++++++++++++++++++++++++	
::

	$ sudo docker stop contenedor-demostracion1

	$ sudo docker stop contenedor-demostracion2

Listar los Contenedores que no estan instanciados
++++++++++++++++++++++++++++++++++++++++++++++++
::

	$ sudo docker ps -f "status=exited"

Iniciar el Contenedores
+++++++++++++++++++++++++++
::

	$ sudo docker start contenedor-demostracion1

Inspeccionar las configuraciones del Contenedores
+++++++++++++++++++++++++++++++++++++++++++++++++
::

	$ sudo docker container inspect contenedor-demostracion1

Borrar un Contenedores
++++++++++++++++++++++
::

	$ sudo docker stop contenedor-demostracion1
	
	$ sudo docker rm contenedor-demostracion1

	$ sudo docker rm contenedor-demostracion2

Borrar una Imagen
++++++++++++++++++++
::

	$ sudo docker images

	$ sudo docker rmi imagen-demostracion:1.0


Borrar Volumen huérfanos
+++++++++++++++++++++++++
::

	$ docker volume rm $(docker volume ls -qf dangling=true)





