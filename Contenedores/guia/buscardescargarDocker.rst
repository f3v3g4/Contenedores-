Buscar y descargar una imagen Docker
===================================

Buscar imágenes
++++++++++++++

Comience a buscar una imagen acoplable. En la lista, obtendremos el archivo de imagen oficial y más confiable en la primera línea.::

	# docker search nginx 

Descargar imágenes al servidor local
+++++++++++++++++++++++++

Para descargar con el archivo de imagen más reciente no es necesario mencionar la versión. Al descargar una imagen sin etiqueta, extraerá la última imagen que tiene "nginx:latest".

Siempre es bueno ir al sitio oficial y obtener más informcion de la imagen:

https://hub.docker.com/

De esta forma descargamos la ultima version dockerizada de nginx::

	# docker pull nginx

De esta otra forma podemos descargar un versión en especifico, pero siempre con la ayuda de https://hub.docker.com/

# docker pull nginx:1.14                  # Descargar la versión estable anterior sin etiqueta

Listar las imágenes descargadas.
++++++++++++++++++++++++++++

Para enumerar las imágenes locales::

	# docker image ls

Iniciar un contenedor desde imágenes docker
+++++++++++++++++++++++++++++++++

No deje de ver la documentacion en https://hub.docker.com/ para saber como se debe iniciar el contenedor y como se debe manipular.

Instanciar la imagen descargada y se convertira en un contenedor::

	# docker run nginx
	$ sudo docker run --name some-nginx -d -p 8080:80 nginx

Para listar el contenedor en ejecución::

	# docker ps

Probar el contenedor, abrir un navegador y colocar http://localhost:8080

Para detener el contenedor::

	# docker stop some-nginx

Para eliminar el contenedor::

	# docker rm some-nginx

Para eliminar la imagen en el servidor local::

	# docker rmi nginx
