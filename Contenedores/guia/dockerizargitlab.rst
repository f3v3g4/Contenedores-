Dokerizar Gitlab paso a paso
===============================

Vamos a Dokerizar Gitlab paso a paso en este docker.

https://medium.com/@1997corry/running-your-own-gitlab-on-docker-community-edition-39c4a8f99553#id_token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjZhOGJhNTY1MmE3MDQ0MTIxZDRmZWRhYzhmMTRkMTRjNTRlNDg5NWIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJuYmYiOjE2MTY3MjEyMTMsImF1ZCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsInN1YiI6IjEwMzQ0Mjc3MDQ4OTA5MzM2MDEzNCIsImVtYWlsIjoiY2dvbWV6bnRAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF6cCI6IjIxNjI5NjAzNTgzNC1rMWs2cWUwNjBzMnRwMmEyamFtNGxqZGNtczAwc3R0Zy5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsIm5hbWUiOiJDYXJsb3MgR8OzbWV6IEcuIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BT2gxNEdqSjVWdUVQR1dLa0lFNHdUZlB6cmFFTFdwb19PYnZLREF6a2M1RlNnPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkNhcmxvcyIsImZhbWlseV9uYW1lIjoiR8OzbWV6IEcuIiwiaWF0IjoxNjE2NzIxNTEzLCJleHAiOjE2MTY3MjUxMTMsImp0aSI6ImRmYTBlNTA5OGMxZmNjMWI1OGQzYjhhNDQ5YzdhMDU0NTA1N2NkMjYifQ.TwhK8k_co0rkkRnhANbDZAsAdg40H9bBNtnRCgqvbpaHYGCBZDj2pIqIO4ht8fY_TTQ3CjluJgMcy9albWPxK91lKU9swRsVQSQ0ccFHoK8kmUFQ4SkOq3SRTZnvHXquvc4A8JNDce4emztHmSnvP2rZXriVAjq8iiqk66CXwjmP1_QQc4ScKlikHEUjvQXCi0jk-JqbwphcMOlyL7306j9aG1at07ZBO-_cUQujgAuRebo51E3-PHnncy-Va3K5E1TF882J7SHAumfyLSZQzWVSnIcyqdYUJTDo8LldYzW7E358zbVbOEFnCXg_zJiVVKYIe1jBeO03miHfplhydA

Hacer una imagen de Docker CE con Dockerfile
++++++++++++++++++++++++++++++++++++++++++++

Vamos a crear una imagen con la ayuda del archivo Dockerfile, dentro de él vamos a colocar todas las lineas de instrucciones necesarias para que se descargue una imagen base, luego dentro de ella vamos a copiar algun archivo y/o instaladores que necesitemos para hacer este docker y por ultimo con el comando build procedemos a crear la imagen.

Crear un directorio de trabajo
++++++++++++++++++++++++++++++
::

	$ mkdir docker
	$ cd /
	$

Así quedaría el archivo Dockerfile y lo copiamos en en directorio docker::

	FROM debian:10.1

	MAINTAINER Carlos Gomez G cgomeznt@gmail.com

	# Declaramos las siguientes variables por recomendaciones d Docker
	ENV     container docker
	ENV	EXTERNAL_URL="http://gitlab.example.com"

	# Instalamos paquetes necesarios para la base que nos permitan administrar y hacer troubleshooting
	ENV TERM=xterm
	RUN apt-get update && \
	    apt-get install -y xterm curl openssh-server ca-certificates postfix vim net-tools

	COPY    gitlab-ce_13.10.0-ce.0_amd64.deb /tmp

	RUN 	dpkg -i /tmp/gitlab-ce_13.10.0-ce.0_amd64.deb

	RUN	apt-get -f install

	RUN sed -i "s/unicorn\['worker_timeout'\] = 60/unicorn\['worker_timeout'\] = 300/g" /etc/gitlab/gitlab.rb

	EXPOSE 22 80 443
	
	# Esta opción se deja comentada porque sino el contenedor se configura y se apaga, para evitar comentarla le colocamos el && tail -f /dev/null y es como un ciclo infinito y hace que el contenedo se quede vivo. NO ME GUSTA
	ENTRYPOINT (/opt/gitlab/embedded/bin/runsvdir-start &) && gitlab-ctl reconfigure

**NOTA**  en este link oficial explica porque la configuración del ENTRYPOINT, si no la aplicamos el Gitlab se quedara en la reconfiguración pegado en esta sesión *** ruby_block[wait for redis service socket] action run**

https://gitlab.com/gitlab-org/omnibus-gitlab/-/issues/4257

Copiar los instaladores necesarios y los archivos de configuración que serán utilizados desde el archivo Dockerfile, en nuestra carpeta de trabajo.

Paso a paso de la creación de la imagen y del contenedor.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Ya que tenemos cuales archivos vamos a utilizar vamos a continuar con un paso a paso técnico.

Nos aseguramos que estamos en el directorio de trabajo y que están todos los archivos requeridos.::

	$ pwd
	$ ls
		Dockerfile  gitlab-ce_13.10.0-ce.0_amd64.deb

Variable de entorno GITLAB_HOME
+++++++++++++++++++++++++++++

Para usuarios Linux, configurar la ruta /home/srv/gitlab::

	export GITLAB_HOME=/home/cgomeznt/srv/gitlab	

Creado la imagen con build
+++++++++++++++++++++++++++
::

	docker build -t "gitlab-ce:1.0" ./


Hacer un listado de las imagenes
+++++++++++++++++++++++++++++++++
::

	$ docker images

Crear el contenedor desde la imagen e iniciarlo
++++++++++++++++++++++++++++++++++++++++++++++++
::

	docker run -dti \
	--hostname gitlab.dominio.local \
	--publish 443:443 \
	--publish 80:80 \
	--publish 22:22 \
	--publish 5000:5005 \
	--name gitlab \
	--shm-size=4g \
	--restart=on-failure \
	--volume $GITLAB_HOME/config:/etc/gitlab \
	--volume $GITLAB_HOME/logs:/var/log/gitlab \
	--volume $GITLAB_HOME/data:/var/opt/gitlab --privileged gitlab-ce:1.0 /usr/sbin/init


Estos argumentos "--privileged "gitlab-ce13.10.0:1.0" /usr/sbin/init" es para que funcione el systemctl 

Visualizar el log
++++++++++++++++++++++++
::

	docker logs -f gitlab


Consultar los contenedores que están iniciados.
+++++++++++++++++++++++++++++++++++++++++++++++
::

	$ docker ps

Ingresar al Contenedor en modo bash 
+++++++++++++++++++++++++++++++++++
Este paso lo ejecutamos si en el Dockerfile dejamos comentada la linea del ENTRYPOINT::

	$ docker exec -i -t gitlab /bin/bash
	[@ecde063fb19c /]$ 

Culminar la configuración de Gitlab
++++++++++++++++++++++++++++++
Este paso lo ejecutamos si en el Dockerfile dejamos comentada la linea del ENTRYPOINT::

	[@ecde063fb19c /]$ /opt/gitlab/embedded/bin/runsvdir-start &
	[@ecde063fb19c /]$ gitlab-ctl reconfigure

Habilitar el Gitlab Container Registry
+++++++++++++++++++++++++++++++++++
Este paso lo ejecutamos si en el Dockerfile dejamos comentada la linea del ENTRYPOINT::

	vi /etc/gitlab/gitlab.rb
	registry_external_url 'http://gitlab.dominio.local'


Dokerizar Gitlab-Runner paso a paso
===============================

Vamos a Dokerizar Gitlab-Runner paso a paso en este docker.

Instalar primero Docker

Como instalarlo
++++++++++++++++

https://docs.gitlab.com/runner/install/linux-manually.html

Como Registrar
+++++++++++++++

https://docs.gitlab.com/runner/register/index.html#linux




