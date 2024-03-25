Docker insecure registry
==========================

Esto es para cambiar que docker busque el registry por HTTPS y lo haga por HTTP, porque docker solo ve como seguro la IP 127.0.0.1 y cualquier otra IP el va abrir por el HTTPS

https://stackoverflow.com/questions/49674004/docker-repository-server-gave-http-response-to-https-client/54190375

https://stackoverflow.com/questions/42211380/add-insecure-registry-to-docker

https://docs.docker.com/config/daemon/

**Detener docker**::

	systemctl stop docker

**Crear el daemon.json** aquí lo explican en Troubleshooting

https://docs.docker.com/config/daemon/ ::


	vi /etc/docker/daemon.json
		{
		"insecure-registries":["registry:5000"]
		}
**En el docker.service** removemos el -H para que pueda leer el archivo daemon.json::

	vi /lib/systemd/system/docker.service
	# remove -H
	ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock

**Recargamos y reiniciamos docker**::

	systemctl daemon-reload                                          
	systemctl start docker

Listo ya podemos llamar al registry por otra IP distinta a la 127.0.0.1 e intentara abrir por HTTP (Insecure Registry)


