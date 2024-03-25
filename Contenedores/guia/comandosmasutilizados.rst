Comandos más utilizados
=======================

Como siemrpe en el link oficial existe una documentación bien completa:

https://docs.docker.com/engine/reference/commandline/docker/

Run
+++++
crear/inicializar un contenedor a partir de una imagen. Al indicarle la imagen, internamente verifica si la tenemos de manera local, si no es así, la descargada de Docker Hub de lo contrario, utiliza la local.

Sintaxis::

	docker run [opciones] [nombre-imagen] [comandos] [argumentos]

Uso básico::
	
	docker run hello-world

Asignar variables de entorno. Utilizamos la imagen mysql, y creamos la env de contraseña::

	docker run -e MYSQL_ROOT_PASSWORD=toor mysql

Correr en background (detach)::

	docker run -d hello-world

Mapear el puerto interno 80 al 8080 público::

	docker run -d -p 8080:80 nginx

Compartir un directorio entre contenedor y local::

	docker run -it -v /mi/path/local:/path/contenedor ubuntu

Compartir volúmenes entre contenedores::

	docker run -it --name ubuntu2 --volumen-from ubuntu1 ubuntu

Asociar volumen creado anteriormente::

	docker run -it mivolumen:/path/contenedor ubuntu

Start
+++++
Iniciar un contenedor detenido, es similar a run, sólo que run crea un contenedor nuevo, y este utiliza uno ya creado

Sintaxis::

	docker start [opciones] [contenedor]

Uso básico::

	docker start 830cb7a4232b

Stats
+++++++
Ver en tiempo real el uso de recursos de cada contenedor

Sintaxis::

	docker stats [opciones] [nombre-contenedor]

Uso básico::

	docker stats

Dar formato a salida::

	docker stats --format "{{.Container}}: {{.CPUPerc}}"

PS
+++
Listar contenedores

Sintaxis::

	docker ps [opciones]

Uso básico::
	
	docker ps

todos los contenedores::

	docker ps -a

Mostrar el uso de disco::

	docker ps -s

Obtener el contenedor id 830cb7a4232b::

	docker ps --filter "id=830cb7a4232b"

Dar formato de salida::

	docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Size}}\t{{.Ports}}"

Último contenedor que ha tenido alguna operación::

	docker ps -l

Últimos 4 contenedores que han tenido alguna operación::

	docker ps -n 4


Images
+++++
Listar imágenes

Sintaxis::
docker images [opciones] [repositorio]
Uso básico::
docker images
Listar imágenes de un repositorio::
docker images hello-world
Listar imágenes de un reposito y tag::
docker images hello-world:latest
Dar formato a salida::
docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}"
Ver historia::
docker image history hello-world


RM
+++
Eliminar contenedores o imágenes. Podemos utilizar rm directamente para eliminar imágenes o contenedores, o podemos usar sus variantes de docker container y docker volume.

Sintaxis::
docker rm [opciones] [contenedor...]
Uso básico::
docker rm 830cb7a4232b
Eliminar contenedor y sus volúmenes::
docker rm -v 830cb7a4232b
Eliminar todos los contenedores::
docker container rm $(docker container ls -aq)
docker rm `docker ps -aq`
docker rm -f $(docker ps -aq)
Eliminar volumen::
docker volume rm 830cb7a4232b


Exec
+++++
Ejecutar un comando dentro de un contenedor

Sintaxis::
docker exec [opciones] [contenedor][comandos...]
Uso básico::
docker exec 7b288331d9c5 echo hola
Ingresar a terminal de contenedor::
docker exec -it 7b288331d9c5 /bin/bash

Logs
+++++
Obtener logs desde los contenedores

Sintaxis::
docker logs [opciones] [contenedor]
Uso básico::
docker logs 7b288331d9c5
Quedar escuchando log::
docker logs -f 7b288331d9c5
Obtener logs de un día en específico::
docker logs --since 2020-07-16T00:00:00 --until 2020-07-16T23:59:59 7b288331d9c5
Filtrar logs por la palabra hola::
docker logs 7b288331d9c5 2>&1 | grep "hola"


Kill
++++
Eliminar contenedores corriendo

Sintaxis::
docker kill [opciones] [contenedores...]
Uso básico::
docker kill 7b288331d9c5


Inspect
+++++++++
Obtener información de configuración de un contenedor

Sintaxis::
docker inspect [opciones] [contenedores...]
Uso básico::
docker inspect 7b288331d9c5
Listar variables de entorno::
docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' 7b288331d9c5
Exportar configuración::
docker inspect 7b288331d9c5 > inspect.txt


Network
+++++++++++
Administración de las redes

Sintaxis::
docker network [comando]
Listar redes::
docker network ls
Eliminar una red::
docker network rm 1104fc7ed905
Eliminar todas las redes no usadas::
docker network prune
Crear una red::
docker network crear mired
Conectar en caliente un contenedor a una red::
docker network connect mired 1104fc7ed905
Desconectar en caliente un contenedor a una red::
docker network disconnect mired 1104fc7ed905


Volume
++++++++
Administración de volúmenes

Sintaxis::
docker volume [comando]
Crear volumen::
docker volume create mivolumen
Revisar volumen::
docker volume inspect mivolumen
Listar volúmenes::
docker volume ls
Eliminar volumen::
docker volume rm mivolumen
Eliminar volumenes que no sean utilizados::
docker volume prune


Commit
++++++
Modificación de contenedores

Sintaxis::
docker commit [opciones] contenedor [repositorio[:TAG]]
Crear imagen de contenedor::
docker commit micontenedor nombre_imagen
#Utilizar esta imagen::
docker run -it nomber_imagen bash


System Prune
++++++++++++++
Eliminar todos los contenedores, redes imágenes, y opcionalmente volúmenes sin usar

Sintaxis::
docker system prune [opciones]
Realizar prune::
docker system prune
Eliminar todas las imágenes, incluso de contenedores detenidos::
docker system prune -a
Eliminar volúmenes::
docker system prune --volumes
