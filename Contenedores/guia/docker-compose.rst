Docker Compose
=============

La mejor documentación es la oficial de Docker

https://docs.docker.com/compose/


¿Busca la referencia de archivo de Redacción?

https://docs.docker.com/compose/compose-file/

https://docs.docker.com/compose/compose-file/compose-file-v3/

https://github.com/compose-spec/compose-spec/blob/master/spec.md

Compose es una herramienta para definir y ejecutar aplicaciones Docker de varios contenedores. Con Compose, usa un archivo YAML para configurar los servicios de su aplicación. Luego, con un solo comando, crea e inicia todos los servicios desde su configuración. Para obtener más información sobre todas las funciones de Compose, consulte la lista de funciones.

https://docs.docker.com/compose/#features


El uso de Compose es básicamente un proceso de tres pasos:

	* Defina el entorno de su aplicación con un Dockerfile para que pueda reproducirse en cualquier lugar.

	* Defina los servicios que componen su aplicación docker-compose.yml para que puedan ejecutarse juntos en un entorno aislado.

	* Ejecutar docker compose up y el comando de composición de Docker se inicia y ejecuta toda la aplicación.

Alternativamente, puede ejecutar docker-compose upusando el binario docker-compose.

Compose tiene comandos para administrar todo el ciclo de vida de su aplicación:

	* Iniciar, detener y reconstruir servicios.

	* Ver el estado de los servicios en ejecución.

	* Transmita la salida del registro de los servicios en ejecución.

	* Ejecute un comando único en un servicio.

Así se ve docker-compose.yml::

	version: "3.9"
	services:

	  web:
	    image: apache-run:1.0
	    container_name: my-web-01
	    ports:
	      - "6379:80"
	    networks:
	      - frontend
	    volumes:
	      - ./html1:/var/www/html
	    privileged: true
	    deploy:
	      replicas: 2
	      placement:
		max_replicas_per_node: 1
	      update_config:
		parallelism: 2
		delay: 10s
	      restart_policy:
		condition: on-failure
		delay: 5s
		max_attempts: 3
		window: 120s
	  web2:
	    image: apache-run:1.0
	    container_name: my-web-02
	    ports:
	      - "8800:80"
	    networks:
	      - frontend
	      - backend
	    volumes:
	      - ./html2:/var/www/html
	    privileged: true

	networks:
	  frontend:
	  backend:



Para instalar Docker Compose
+++++++++++++++++++++++++

https://docs.docker.com/compose/install/


Vamos hacer el laboratorio
+++++++++++++++++++++

Este laboratorio consiste en que se generen dos contenedores desde nuestra imagen apache-run:1.0 y que cada uno tenga una ruta persistente con archivos index.html independientes para el uso del apache, que los contenedores este por puertos distintos, crearemos dos 2 redes, uno de los servicios lo vamos a configurar para que tenga 2 replicas en dos host distintos y por ultimo que uno de los servicios tenga una política de restart si ocurre una falla.

**Preparamos el directorio de trabajo**::

	mkdir -p /home/laboratorio/{html1,html2}

**Creamos un index para que corra en uno de los contenedores de apache**::

	$ vi html1/index.html 
		<html>
		  <head>
			<title>www.Docker-Demostracion.com</title>
		  </head>
		  <body>
			<h1>Service Web 1</h1>
			<h1>Felicitaciones, esta es un Apache dentro de un Contenedor Docker Demostracion</h1>
			<h3>Felicitaciones, Creado con Docker Compose, service web</h3>
		  </body>
		</html>

**Creamos otro index para el otro contenedores de apache**::

	$ cat html2/index.html 
		<html>
		  <head>
			<title>www.Docker-Demostracion.com</title>
		  </head>
		  <body>
			<h1>Service Web 2</h1>
			<h1>Felicitaciones, esta es un Apache dentro de un Contenedor Docker Demostracion</h1>
			<h3>Felicitaciones, Creado con Docker Compose, service web2 </h3>
		  </body>
		</html>

**Creamos nuestro docker-compose.yml**::

	$ cat docker-compose.yml 
	version: "3.9"
	services:

	  web:
	    image: apache-centos7:1.0
	    container_name: my-web-01
	    ports:
	      - "8080-8082:80"
	    networks:
	      - frontend
	    volumes:
	      - ./html1:/var/www/html
	    privileged: true
	    deploy:
	      replicas: 1
	      placement:
		max_replicas_per_node: 1
	      update_config:
		parallelism: 2
		delay: 10s
	      restart_policy:
		condition: on-failure
		delay: 5s
		max_attempts: 3
		window: 120s
	  web2:
	    image: apache-alpine:1.0
	    container_name: my-web-02
	    ports:
	      - "8090:80"
	    networks:
	      - frontend
	      - backend
	    volumes:
	      - ./html2:/var/www/localhost/htdocs

	networks:
	  frontend:
	  backend:




**Iniciamos el Docker Compose**::

	$ docker-compose up -d
	WARNING: The following deploy sub-keys are not supported and have been ignored: update_config, restart_policy.delay, restart_policy.window
	Creating network "laboratorio_frontend" with the default driver
	Creating network "laboratorio_backend" with the default driver
	Creating laboratorio_web_1 ... done
	Creating my-web-02         ... done


**Consultamos docker-compose ps**::

	$ docker-compose ps
	WARNING: The following deploy sub-keys are not supported and have been ignored: update_config, restart_policy.delay, restart_policy.window
	      Name                     Command               State                  Ports                
	-------------------------------------------------------------------------------------------------
	laboratorio_web_1   /usr/sbin/init                   Up      0.0.0.0:8081->80/tcp,:::8081->80/tcp
	my-web-02           /bin/sh -c exec /usr/sbin/ ...   Up      0.0.0.0:8090->80/tcp,:::8090->80/tcp



**Consultamos la Redes**::

	$ docker network ls
	NETWORK ID     NAME                   DRIVER    SCOPE
	9e8850053305   bridge                 bridge    local
	762da95dd63f   host                   host      local
	eeecce6d7ed9   laboratorio_backend    bridge    local
	9cb0201871fd   laboratorio_frontend   bridge    local
	2ea85b178fec   none                   null      local

**Vemos con docker los contenedores**::

	$ docker ps 
	CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS          PORTS                                   NAMES
	8ee0e688e2a3   apache-centos7:1.0       "/usr/sbin/init"         15 minutes ago   Up 15 minutes   0.0.0.0:8082->80/tcp, :::8082->80/tcp   laboratorio_web_1
	1fb811ba2f9e   apache-alpine:1.0        "/bin/sh -c 'exec /u…"   15 minutes ago   Up 15 minutes   0.0.0.0:8090->80/tcp, :::8090->80/tcp   my-web-02

**Verificamos el contenido de los contenedores**::

	$ docker container inspect laboratorio_web_1
	$ docker container inspect my-web-02

**Detenemos y removemos todos los servicios creados con docker compose**::

	$ docker-compose down
	WARNING: The following deploy sub-keys are not supported and have been ignored: update_config, restart_policy.delay, restart_policy.window
	Stopping my-web-02         ... done
	Stopping laboratorio_web_1 ... done
	Removing my-web-02         ... done
	Removing laboratorio_web_1 ... done
	Removing network laboratorio_frontend
	Removing network laboratorio_backend



Editamos el archivo docker-compose.yml, buscamos estas lineas::

	replicas: 1
	max_replicas_per_node: 1

cambiamos el 1 por 2, nos queda así::

	replicas: 2
	max_replicas_per_node: 2

Buscamos esta también y la removemos, porque para hacerlo escalable no podemos tener los nombres especificado de los containers::

	container_name: my-web-01

Volvemos a crear e iniciar los contedores publicados en el YML, póngale cuidado a lo que dice los Warning y donde dice Creating::

	$ docker-compose up -d
	WARNING: The following deploy sub-keys are not supported and have been ignored: update_config, restart_policy.delay, restart_policy.window
	Creating network "laboratorio_frontend" with the default driver
	Creating network "laboratorio_backend" with the default driver
	WARNING: The "web" service specifies a port on the host. If multiple containers for this service are created on a single host, the port will clash.
	Creating my-web-02         ... done
	Creating laboratorio_web_1 ... done
	Creating laboratorio_web_2 ... done


Consultamos docker-compose ps::

	$ docker-compose ps 
	WARNING: The following deploy sub-keys are not supported and have been ignored: update_config, restart_policy.delay, restart_policy.window
	      Name                     Command               State                  Ports                
	-------------------------------------------------------------------------------------------------
	laboratorio_web_1   /usr/sbin/init                   Up      0.0.0.0:8080->80/tcp,:::8080->80/tcp
	laboratorio_web_2   /usr/sbin/init                   Up      0.0.0.0:8082->80/tcp,:::8082->80/tcp
	my-web-02           /bin/sh -c exec /usr/sbin/ ...   Up      0.0.0.0:8090->80/tcp,:::8090->80/tcp




Consultamos docker ps::

	docker ps 
	CONTAINER ID   IMAGE                    COMMAND                  CREATED          STATUS          PORTS                                   NAMES
	fbf0242c9fe8   apache-centos7:1.0       "/usr/sbin/init"         56 seconds ago   Up 54 seconds   0.0.0.0:8082->80/tcp, :::8082->80/tcp   laboratorio_web_2
	1a45f1e285c7   apache-centos7:1.0       "/usr/sbin/init"         56 seconds ago   Up 54 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   laboratorio_web_1
	78743b8adcb0   apache-alpine:1.0        "/bin/sh -c 'exec /u…"   56 seconds ago   Up 53 seconds   0.0.0.0:8090->80/tcp, :::8090->80/tcp   my-web-02



Consultamos las redes::

	$ docker network ls
	NETWORK ID     NAME                   DRIVER    SCOPE
	9e8850053305   bridge                 bridge    local
	762da95dd63f   host                   host      local
	279e27758f49   laboratorio_backend    bridge    local
	eac4318c96e9   laboratorio_frontend   bridge    local
	2ea85b178fec   none                   null      local

Vamos ahora a un navegador y probamos estas tres (3) URL y leemos el contenido que nos ayuda a identificar:

localhost:8080

localhost:8082

localhost:8090

**Ahora vamos a probar que funcione el restart cuando existe una falla**


Primero vamos a consultar docker ps y vemos la columna STATUS cuanto tiempo tiene de vida los contenedores::

	$ docker ps
	CONTAINER ID   IMAGE                    COMMAND                  CREATED         STATUS         PORTS                                   NAMES
	fbf0242c9fe8   apache-centos7:1.0       "/usr/sbin/init"         3 minutes ago   Up 3 minutes   0.0.0.0:8082->80/tcp, :::8082->80/tcp   laboratorio_web_2
	1a45f1e285c7   apache-centos7:1.0       "/usr/sbin/init"         3 minutes ago   Up 3 minutes   0.0.0.0:8080->80/tcp, :::8080->80/tcp   laboratorio_web_1
	78743b8adcb0   apache-alpine:1.0        "/bin/sh -c 'exec /u…"   3 minutes ago   Up 3 minutes   0.0.0.0:8090->80/tcp, :::8090->80/tcp   my-web-02


En este caso tiene 3 minutos.

Ahora vamos a consultar uno de los contenedores cual es su PID::

	$ docker container inspect laboratorio_web_2 | grep Pid
		    "Pid": 1338,
		    "PidMode": "",
		    "PidsLimit": null,


Matamos el PID del contenedor::

	$ sudo kill -9 1338

Inmediatamente volvemos a consultar docker ps::

	$ docker ps
	CONTAINER ID   IMAGE                    COMMAND                  CREATED         STATUS          PORTS                                   NAMES
	fbf0242c9fe8   apache-centos7:1.0       "/usr/sbin/init"         4 minutes ago   Up 11 seconds   0.0.0.0:8081->80/tcp, :::8081->80/tcp   laboratorio_web_2
	1a45f1e285c7   apache-centos7:1.0       "/usr/sbin/init"         4 minutes ago   Up 4 minutes    0.0.0.0:8080->80/tcp, :::8080->80/tcp   laboratorio_web_1
	78743b8adcb0   apache-alpine:1.0        "/bin/sh -c 'exec /u…"   4 minutes ago   Up 4 minutes    0.0.0.0:8090->80/tcp, :::8090->80/tcp   my-web-02


Vemos como inmediatamente se crea nuevamente el contenedor, se evidencia que tiene de vida 11 segundos











