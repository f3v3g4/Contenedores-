Monitorizar Docker
==========

docker info
+++++++++++++

Docker info es lo primero que siempre debemos consultar y tener claro::

	$ docker info

docker logs
++++++++++++++

Hagamos este ejercicio para entender mejor, corremos un contenedor y le mandamos a ejecutar un ciclo infinito que muestre la fecha actual::

	$ docker run -dti --name apache4.0 apache:1.0 /bin/bash -c "while true ; do date && sleep 4 ; done"

Cuando terminemos, vemos que no tenemos nada por la TTY, pues vamos utilizar el comando docker logs para ver los logs del contenedor::

	$ docker logs apache4.0
	Sat May 29 01:14:50 UTC 2021
	Sat May 29 01:14:54 UTC 2021
	Sat May 29 01:14:58 UTC 2021
	$

Y para dejar los logs vivos utilizamos el -f ::

	$ docker logs -f apache4.0
	Sat May 29 01:14:50 UTC 2021
	Sat May 29 01:14:54 UTC 2021
	Sat May 29 01:14:58 UTC 2021
	Sat May 29 01:15:02 UTC 2021
	Sat May 29 01:15:06 UTC 2021
	[..continua...]

También podemos direccionar la salida a un STDOUT::

	$ docker logs -f apache4.0 > docker.log

o::

	$ docker logs -f apache4.0 | tee docker.log


docker stats
+++++++++++++

Muestra en vivo las estadisticas de los recursos del contenedor::

	$ docker stats

	CONTAINER ID   NAME                CPU %     MEM USAGE / LIMIT    MEM %     NET I/O       BLOCK I/O     PIDS
	a4963f6a564e   apache4.0           0.00%     1.891MiB / 7.72GiB   0.02%     9.34kB / 0B   73.7kB / 0B   2
	ea05b40a8c2d   my-web-02           0.00%     26.25MiB / 7.72GiB   0.33%     63.2kB / 0B   2.8MB / 0B    12
	2da3029979f0   laboratorio_web_2   0.00%     25.46MiB / 7.72GiB   0.32%     28.9kB / 0B   529kB / 0B    11


docker events
+++++++++++++

Obtiene los eventos en tiempo real del servidor


docker container inspect contenedor
++++++++++++++++++++++++++++++++++++

Muestra una información detallada de uno o más contenedores::

	$ docker container inspect apache1.0


Ver los logs en le HOST
++++++++++++++++++++++++++++++

En el HOST es muy util tambien saber que sucede con el demonio dockerd::

	# journalctl -u docker.service 
	
También podemos hacer auditoría en el log del sistema /var/log/messages::

	# less /var/log/messages | grep docker



