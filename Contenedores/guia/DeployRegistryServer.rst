Deploy a Registry Server
=======================

https://docs.docker.com/registry/deploying/

**Run a local registry** Usar el siguiente comando para instanciar un contenedor de registry::

	$ docker run -d -p 5000:5000 --restart=always --name registry registry:2

Pull the ubuntu:16.04 image from Docker Hub.::

	$ docker pull ubuntu:16.04

Tag the image as localhost:5000/my-ubuntu. This creates an additional tag for the existing image. When the first part of the tag is a hostname and port, Docker interprets this as the location of a registry, when pushing.::

	$ docker tag ubuntu:16.04 localhost:5000/my-ubuntu

Push the image to the local registry running at localhost:5000::

	$ docker push localhost:5000/my-ubuntu

Remove the locally-cached ubuntu:16.04 and localhost:5000/my-ubuntu images, so that you can test pulling the image from your registry. This does not remove the localhost:5000/my-ubuntu image from your registry.::

	$ docker image remove ubuntu:16.04
	$ docker image remove localhost:5000/my-ubuntu

Correr un Registry accesible desde otros servidores
+++++++++++++++++++++++++++++++++++++

Correr el registry  de forma insegura es solo accesible desde localhost. Para poder crear un registry accesible desde host externos, debemos configurar primero los TLS.

Debemos crear los certificados primero con **openssl**, creamos un directorio de trabajo::

	mkdir certs
	cd certs

Ahora sigue este procedimiento de crear un certificado auto firmado. Este procedimiento lo debemos crear en el Host. Poner atención cuando en la creación del Request (crs) consulten <Common Name (e.g. server FQDN or YOUR name)> aquí se debe especificar el nombre correcto del servidor a nivel de DNS o el nombre que se utilizara en los archivos HOSTS. En este ejemplo debe ser registry.dominio.local

https://github.com/cgomeznt/openssl/blob/master/guia/Autofirmado.rst


Luego que tengamos los certificados los debemos crear una carpeta en los servidores que vayan a utilizar el Docker Registry::

	mkdir -p /etc/docker/certs.d/NOMBRE_DEL_CONTENEDOR\:PUERTO/

	mkdir -p /etc/docker/certs.d/registry.dominio.local\:4443/

Y dentro de esa carpeta debemos copiar el certificado del servidor y la CA que lo firmo::

	cp registry.crt rootCA.crt /etc/docker/certs.d/NOMBRE_DEL_CONTENEDOR\:PUERTO/

	cp registry.crt rootCA.crt /etc/docker/certs.d/registry.dominio.local\:4443/

**NOTA** Si omites los pasos anteriores te encontraras con este error <Get https://registry.dominio.local:4443/v2/: x509: certificate signed by unknown authority
>
Se instancia el contenedor de Registry, debemos estar un peldaño sobre la carpeta certs, donde están los certificados::

	docker run -d \
	  --restart=always \
	  --name registry.dominio.local \
	  -v "$(pwd)"/certs:/certs \
	  -e REGISTRY_HTTP_ADDR=0.0.0.0:4443 \
	  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
	  -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
	  -p 4443:4443 \
	  --network app \
	  registry:2

Consultamos que IP tiene::

	docker container inspect registry.dominio.local | grep IPAddress

La IP que nos arroje se la cargamos a nuestro archivo HOST en donde esta corriendo el contenedor::

	echo "172.18.0.3	registry.dominio.local" >> /etc/hosts

Probamos desde el HOST el ping::

	ping -c2 registry.dominio.local

Vemos que imágenes tiene el Registry::

	curl -k https://registry.dominio.local:4443/v2/_catalog


descargamos una imagen de prueba::

	docker pull alpine

	docker tag alpine:latest registry.dominio.local:4443/alpine

	docker images

	docker push registry.dominio.local:4443/alpine

Volvemos a verificar que imágenes tiene el Registry::

	curl -k https://registry.dominio.local:4443/v2/_catalog

Listo ...!!!
