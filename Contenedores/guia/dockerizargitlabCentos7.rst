Dokerizar Gitlab Gitlab-Runner Centos 7
===============================

Vamos a Dokerizar Gitlab, Gitlab-Runner paso a paso en este docker.

Recordemos deshabilitar el selinux y firewall, importante tener una buena configuración de DNS o en el archivo HOSTS, nuestro dominio se llamara **dominio.local** y también vamos a crear una Network de docker llamada **app** para que los contenedores puedan resolver por nombre DNS

**Descargamos una imagen de Centos 7**::

	docker search centos

	docker pull centos:7

	docker images 

**Crear un directorio de trabajo**::

	mkdir laboratorio
	cd laboratorio

**Creamos un Network en docker**::

	docker network create app
	docker network ls
	docker network inspect app

**Creamos la variable para un volumen permanente**::

	export GITLAB_HOME="/home/cgomeznt/srv/gitlab"
	echo $GITLAB_HOME
	rm -rf  $GITLAB_HOME/*

**Instanciamos el contenedor**::

	docker run -dti \
	--hostname gitlab.dominio.local \
	--publish 443:443 \
	--publish 80:80 \
	--publish 22:22 \
	--name gitlab.dominio.local \
	--restart=on-failure \
	--network app \
	--volume $GITLAB_HOME/config:/etc/gitlab \
	--volume $GITLAB_HOME/logs:/var/log/gitlab \
	--volume $GITLAB_HOME/data:/var/opt/gitlab --privileged centos:7 /usr/sbin/init

**Consultamos el contenedor**::

	docker ps
	docker container inspect gitlab.dominio.local

**Descargar el gitlab y gitlab-runner**

https://about.gitlab.com/install/

https://docs.gitlab.com/runner/install/linux-manually.html

**Copiamos el instalador gitlab y gitlab-runner** dentro del contenedor ::

	docker cp gitlab-ce-13.10.0-ce.0.el7.x86_64.rpm gitlab/tmp
	docker cp gitlab-runner_amd64.rpm gitlab/tmp

**Ingresamos en le contenedor**::

	docker exec -ti gitlab.dominio.local bash

**Instalamos los pre-requisitos**::
	
	yum update
	yum install -y xterm curl openssh-server ca-certificates postfix policycoreutils-python vim net-tools git

**Instalamos gitlab**::

	rpm -ivh /tmp/gitlab-ce-13.10.0-ce.0.el7.x86_64.rpm

**Modificamos el worker_timeout** para evitar que nos errores por timeout, error 502::

	sed -i "s/\# unicorn\['worker_timeout'\] = 60/unicorn\['worker_timeout'\] = 300/g" /etc/gitlab/gitlab.rb

**Editamos la URL** y la colocamos con nuestro dominio::

	sed -i 's/gitlab.example.com/gitlab.dominio.local/g' /etc/gitlab/gitlab.rb

**Iniciamos el servicio de gitlab** Esto lo debes ejecutar cada vez que inicies el contenedor, **NOTA**  en este link oficial::

https://gitlab.com/gitlab-org/omnibus-gitlab/-/issues/4257

explica porque esta configuración, si no la aplicamos el Gitlab se quedara en la reconfiguración, es decir, pegado en esta sesión ** ruby_block[wait for redis service socket] action run**, entonces ejecutemos el siguiente comando dentro del contenedor::

	(/opt/gitlab/embedded/bin/runsvdir-start &) && gitlab-ctl reconfigure

Veremos unos errores de sysctl referentes a valores del kernel, pero podemos continuar. (Luego corregiremos este BUG)

Nos salimos del contenedor y consultamos que IP tiene::

	docker container inspect gitlab.dominio.local | grep IPAddress

La IP que nos arroje se la cargamos a nuestro archivo HOST en donde esta corriendo el contenedor::

	echo "172.18.0.2	gitlab.dominio.local" >> /etc/hosts

También podemos utilizar la IP del HOST::

	echo "192.168.1.5	gitlab.dominio.local" >> /etc/hosts

Probemos desde el HOST el ping ::

	ping -c2 gitlab.dominio.local

Listo, con esto ya podemos cargar la pagina de gitlab y cambiar la clave de root, http://gitlab.dominio.local

http://gitlab.dominio.local

.. figure:: https://github.com/cgomeznt/Gitlab/blob/master/images/01.png


**Instalamos Docker**

**Ingresamos en le contenedor** para instalar el Docker::

	docker exec -ti gitlab.dominio.local bash

https://docs.docker.com/engine/install/centos/ ::

	yum install -y yum-utils

	yum-config-manager \
	    --add-repo \
	    https://download.docker.com/linux/centos/docker-ce.repo

	yum install -y docker-ce docker-ce-cli containerd.io

**Iniciamos docker**::

	systemctl enable docker
	systemctl start docker
	systemctl status docker
	docker run hello-world


**Instalar gitlab-runner**

https://docs.gitlab.com/runner/install/linux-manually.html ::

	rpm -ivh /tmp/gitlab-runner_amd64.rpm
	systemctl status gitlab-runner
	gitlab-runner --version
		Version:      14.0.1
		Git revision: c1edb478
		Git branch:   refs/pipelines/326100216
		GO version:   go1.13.8
		Built:        2021-06-23T16:35:23+0000
		OS/Arch:      linux/amd64


**El usuario gitlab-runner debe estar en el grupo Docker**::

	usermod -aG docker gitlab-runner
	newgrp docker
	id gitlab-runner

	su - gitlab-runner
	$ docker info

**Instalamos una versión superior de git** porque el git 1.8.3.1 No soporta git fetch-pack

https://stackoverflow.com/questions/56663096/gitlab-runner-doesnt-work-on-a-specific-project ::

	git --version
	git version 1.8.3.1 # No soporta git fetch-pack

	yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.7-1.x86_64.rpm
	yum -y install git
	git --version
	git version 2.30.1


**Registramos un runner dentro del gitlab** debemos tener primero el token de gitlab, ingresemos a gitlab.dominio.local, y buscamos Admin area -> Overview -> Runner

.. figure:: https://github.com/cgomeznt/Gitlab/blob/master/images/Docker/02.png

Vamos a continuar dentro del contenedor y hacer un registro de gitlab-runner del tipo shell ::

	gitlab-runner register

		Enter the GitLab instance URL (for example, https://gitlab.com/):
		http://gitlab.dominio.local
		Enter the registration token:
		uPKaQBaMJy2hN5Po25Fg
		Enter a description for the runner:
		[gitlab.dominio.local]: Runner para ejecutar shell
		Enter tags for the runner (comma-separated):
		shell-demo
		Registering runner... succeeded                     runner=uPKaQBaM
		Enter an executor: shell, virtualbox, kubernetes, ssh, docker+machine, docker-ssh+machine, custom, docker, docker-ssh, parallels:
		shell
		Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded! 


Veamos en el servidor de Gitlab nuestro registro del Gitlab-runner

.. figure:: https://github.com/cgomeznt/Gitlab/blob/master/images/CICD/12.png


Ahora vamos a revisar el runner que se asocia dentro de un proyecto de Gitlab, no deje de certificar que el servicio de gitlab-runner este iniciado y en donde este instalado el gitlab-runner debe ser capaz de resolver por DNS y IP al servidor gitlab.dominio.local. busca un proyecto y en el menú Settting -> CI/CD del proyecto -> Runners.

.. figure:: https://github.com/cgomeznt/Gitlab/blob/master/images/CICD/13.png


**Probando el gitlab-runner**, creamos un .gitlab-ci.yml. Dentro del .gitlab-ci.yml se configuran los pipeline GitLab CI/CD.

Crear un proyecto nuevo, yo lo llamare **my-app** y lo clonamos en nuestro directorio de trabajo::

	git clone http://gitlab.dominio.local/root/my-app.git
		Clonando en 'my-app'...
		warning: Pareces haber clonado un repositorio sin contenido.

Nos pasamos al repositorio clonado::

	cd my-app 

Crear el archivo .gitlab-ci.yml. El archivo tendrá el siguiente contenido:::

	vi .gitlab-ci.yml

	stages:
	  - test
	  - deploy

	Test:
	  stage: test
	  tags:
	  - shell-demo
	  script:
	    - echo "write your test here...!!!"
	 
	Deploy:
	  only:
	    refs:
	      - master
	  stage: deploy
	  tags:
	    - shell-demo
	  script:
	    - touch /tmp/prueba.txt

**NOTA** pendiente con el la linea del tags: ese nombre debe ser igual al nombre que le dieron al runner, es decir, desde aquí estamos invocando a un runner y debe coincidir los nombres

Agregamos los cambios, hacemos el commit y subimos los cambios a nuestro proyecto::

	git add .gitlab-ci.yml && git commit -m "My First Commit" && git push origin master

Cuando realice cualquier push  se vera algo como esto, estará en pending o running mientras ejecuta todo.


.. figure:: https://github.com/cgomeznt/Gitlab/blob/master/images/Docker/05.png


Si no hay errores, después de un rato vera esto


.. figure:: https://github.com/cgomeznt/Gitlab/blob/master/images/Docker/06.png


Ahora para ver las salidas debe hacer esto, hacer click en passed. Luego hacer click en Test y Deploy para ver el detalle


.. figure:: https://github.com/cgomeznt/Gitlab/blob/master/images/Docker/07.png



.. figure:: https://github.com/cgomeznt/Gitlab/blob/master/images/Docker/10.png


Este es el detalle de Test

.. figure:: https://github.com/cgomeznt/Gitlab/blob/master/images/Docker/08.png


.. figure:: https://github.com/cgomeznt/Gitlab/blob/master/images/Docker/09.png

Listo ya con esto tenemos Dockerizado Gitlab y Gitlab-Runner en un mismo contenedor, recuerda que cada vez que inicies el contenedor debes ejecutar este comando::

	(/opt/gitlab/embedded/bin/runsvdir-start &) && gitlab-ctl reconfigure


Recuerda hacer un docker commit


Running handlers:
There was an error running gitlab-ctl reconfigure:

execute[reload all sysctl conf] (package::sysctl line 18) had an error: Mixlib::ShellOut::ShellCommandFailed: Expected process to exit with [0], but received '255'
---- Begin output of sysctl -e --system ----
STDOUT: * Applying /usr/lib/sysctl.d/10-default-yama-scope.conf ...
kernel.yama.ptrace_scope = 0
* Applying /usr/lib/sysctl.d/50-default.conf ...
kernel.sysrq = 16
kernel.core_uses_pid = 1
kernel.kptr_restrict = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.promote_secondaries = 1
net.ipv4.conf.all.promote_secondaries = 1
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
* Applying /etc/sysctl.d/90-omnibus-gitlab-kernel.sem.conf ...
kernel.sem = 250 32000 32 262
* Applying /etc/sysctl.d/90-omnibus-gitlab-kernel.shmall.conf ...
kernel.shmall = 4194304
* Applying /etc/sysctl.d/90-omnibus-gitlab-kernel.shmmax.conf ...
kernel.shmmax = 17179869184
* Applying /etc/sysctl.d/90-omnibus-gitlab-net.core.somaxconn.conf ...
net.core.somaxconn = 1024
* Applying /etc/sysctl.conf ...
STDERR: sysctl: cannot open "/etc/sysctl.conf": No such file or directory
---- End output of sysctl -e --system ----
Ran sysctl -e --system returned 255

