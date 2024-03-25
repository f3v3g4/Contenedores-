Que es Dockerfile
======================

Docker puede construir imágenes automáticamente leyendo las instrucciones de un Dockerfile. Un Dockerfile es un documento de texto que contiene todos los comandos que un usuario podría llamar en la línea de comando para ensamblar una imagen. Al usar Docker los usuarios de compilación pueden crear una compilación automatizada que ejecuta varias instrucciones de línea de comandos en sucesión.

Dockerfile: Creación de imágenes docker
++++++++++++++++++++++++++++++++++++++++

Usando el comando docker buid y definiendo las características que queremos que tenga la imagen en un fichero Dockerfile crearemos una imagen nueva.


Un Dockerfile es un fichero de texto donde indicamos los comandos que queremos ejecutar sobre una imagen base para crear una nueva imagen. El comando docker build construye la nueva imagen leyendo las instrucciones del fichero Dockerfile y la información de un entorno, que para nosotros va a ser un directorio (aunque también podemos guardar información, por ejemplo, en un repositorio git).
La creación de la imagen es ejecutada por el docker engine, que recibe toda la información del entorno, por lo tanto es recomendable guardar el Dockerfile en un directorio vacío y añadir los ficheros necesarios para la creación de la imagen. El comando docker build ejecuta las instrucciones de un Dockerfile línea por línea y va mostrando los resultados en pantalla.
Tenemos que tener en cuenta que cada instrucción ejecutada crea una imagen intermedia, una vez finalizada la construcción de la imagen nos devuelve su id. Alguna imágenes intermedias se guardan en caché, otras se borran. Por lo tanto, si por ejemplo, en un comando ejecutamos cd /scripts/ y en otra linea le mandamos a ejecutar un script (./install.sh) no va a funcionar, ya que ha lanzado otra imagen intermedia. Teniendo esto en cuenta, la manera correcta de hacerlo sería::

	cd /scripts/;./install.sh

Para terminar indicar que la creación de imágenes intermedias generadas por la ejecución de cada instrucción del Dockerfile, es un mecanismo de caché, es decir, si en algún momento falla la creación de la imagen, al corregir el Dockerfile y volver a construir la imagen, los pasos que habían funcionado anteriormente no se repiten ya que tenemos a nuestra disposición las imágenes intermedias, y el proceso continúa por la instrucción que causó el fallo.
**Los contenedores deber ser “efímeros”**
Cuando decimos “efímeros” queremos decir que la creación, parada, despliegue de los contenedores creados a partir de la imagen que vamos a generar con nuestro Dockerfile debe tener una mínima configuración.

**Uso de ficheros .dockerignore**
Todos los ficheros del contexto se envían al docker engine, es recomendable usar un directorio vacío donde vamos creando los ficheros que vamos a enviar. Además, para aumentar el rendimiento, y no enviar al daemon ficheros innecesarios podemos hacer uso de un fichero .dockerignore, para excluir ficheros y directorios.
**No instalar paquetes innecesarios**
Para reducir la complejidad, dependencias, tiempo de creación y tamaño de la imagen resultante, se debe evitar instalar paquetes extras o innecesarios Si algún paquete es necesario durante la creación de la imagen, lo mejor es desinstalarlo durante el proceso.
**Minimizar el número de capas**
Debemos encontrar el balance entre la legibilidad del Dockerfile y minimizar el número de capa que utiliza.
**Indicar las instrucciones a ejecutar en múltiples líneas**
Cada vez que sea posible y para hacer más fácil futuros cambios, hay que organizar los argumentos de las instrucciones que contengan múltiples líneas, esto evitará la duplicación de paquetes y hará que el archivo sea más fácil de leer. Por ejemplo::
	
	RUN apt-get update && apt-get install -y \
	git \
	wget \
	apache2 \
	php5



Instrucciones de Dockerfile
++++++++++++++++++++++++++++

Introducción al uso de las instrucciones más usadas que podemos definir dentro de un fichero Dockerfile, para una descripción más detallada consulta la documentación oficial. https://docs.docker.com/engine/reference/builder/#format

**FROM:** indica la imagen base que va a utilizar para seguir futuras instrucciones. Buscará si la imagen se encuentra localmente, en caso de que no, la descargará de internet.::

	FROM centos:7

**MAINTAINER:** Nos permite configurar datos del autor, principalmente su nombre y su dirección de correo electrónico.::

	MAINTAINER Carlos Gomez G cgomeznt@gmail.com

**ENV:** Configura las variables de entorno.::

	ENV	export MW_HOME=/u01/app/oracle/middleware

**ADD:** Esta instrucción se encarga de copiar los ficheros y directorios desde una ubicación especificada y los agrega al sistema de ficheros del contenedor. Si se trata de añadir un fichero comprimido, al ejecutarse el guión lo descomprimirá de manera automática.::

	ADD Generate-Schematool.tar /u01/software

**COPY:** Es la expresión recomendada para copiar ficheros, similar a ADD.::

	COPY	jdk-7u79-linux-x64.rpm	/u01/software

**RUN:** Esta instrucción ejecuta cualquier comando en una capa nueva encima de una imagen y hace un commit de los resultados. Esa nueva imagen intermedia es usada para el siguiente paso en el Dockerfile. RUN tiene 2 formatos::

	El modo shell: /bin/sh -c
		RUN comando
::

	Modo ejecución:
		RUN ["ejecutable", "parámetro1", "parámetro2"]

El modo ejecución nos permite correr comandos en imágenes bases que no cuenten con /bin/sh , nos permite además hacer uso de otra shell si así lo deseamos, ejemplo::

	RUN ["/bin/bash", "-c", "echo prueba"]

**EXPOSE:** Indica los puertos en los que va a escuchar el contenedor. Hay que tener en cuenta que esta opción no consigue que los puertos sean accesibles desde el host; para esto debemos utilizar la exposición de puertos mediante la opción -p de docker run.::

	EXPOSE 80 443

**VOLUME:** Nos permite utilizar en el contenedor una ubicación de nuestro host, y así, poder almacenar datos de manera permanente. Los volúmenes de los contenedores siempre son accesibles en el host anfitrión, en la ubicación: /var/lib/docker/volumes/::

	VOLUME "/opt/tomcat/webapps"

**WORKDIR:** El directorio por defecto donde ejecutaremos las acciones.::

	WORKDIR /opt/tomcat

**USER:** Por defecto, todas las acciones son realizadas por el usuario root. Aquí podemos indicar un usuario diferente.::

	USER	oracle

**SHELL:** En los contenedores, el punto de entrada es el comando /bins/sh -c para ejecutar los comandos específicos en CMD, o los comandos especificados en línea de comandos para la acción run.

**ARG:** Podemos añadir parámetros a nuestro Dockerfile para distintos propósitos.::

	ARG PORT=7021

**CMD y ENTRYPOINT:** Estas dos instrucciones son muy parecidas, aunque se utilizan en situaciones diferentes, y además pueden ser usadas conjuntamente, en el siguiente artículo se explica muy bien su uso.
Estas dos instrucciones nos permiten especificar el comando que se va a ejecutar por defecto, sino indicamos ninguno cuando ejecutamos el docker run. Normalmente las imágenes bases (debian, ubuntu,…) están configuradas con estas instrucciones para ejecutar el comando /bin/sh o /bin/bash. Podemos comprobar el comando por defecto que se ha definido en una imagen con el siguiente comando::

	$ docker inspect debian
	...
	 "Cmd": [
		        "/bin/bash"
		    ],
	...

Por lo tanto no es necesario indicar el comando como argumento, cuando se inicia un contenedor::

	$ docker run -i -t  debian


CMD tiene tres formatos::
	Formato de ejecución:
		CMD ["ejecutable", "parámetro1", "parámetro2"]
	Modo shell:
		CMD comando parámetro1 parámetro2
	Formato para usar junto a la instrucción ENTRYPOINT
		CMD ["parámetro1","parámetro2"]

Solo puede existir una instrucción CMD en un Dockerfile, si colocamos más de una, solo la última tendrá efecto.Se debe usar para indicar el comando por defecto que se va a ejecutar al crear el contenedor, pero permitimos que el usuario ejecute otro comando al iniciar el contenedor.
ENTRYPOINT tiene dos formatos::

	Formato de ejecución:
		ENTRYPOINT ["ejecutable", "parámetro1", "parámetro2"]
	Modo shell:
		ENTRYPOINT comando parámetro1 parámetro2

Esta instrucción también nos permite indicar el comando que se va ejecutar al iniciar el contenedor, pero en este caso el usuario no puede indicar otro comando al iniciar el contenedor. Si usamos esta instrucción no permitimos o no  esperamos que el usuario ejecute otro comando que el especificado. Se puede usar junto a una instrucción CMD, donde se indicará los parámetro por defecto que tendrá el comando indicado en el ENTRYPOINT. Cualquier argumento que pasemos en la línea de comandos mediante docker run serán anexados después de todos los elementos especificados mediante la instrucción ENTRYPOINT, y anulará cualquier elemento especificado con CMD.
Ejemplo
Si tenemos un fichero Dockerfile, que tiene las siguientes instrucciones::

	ENTRYPOINT [“http”, “-v ]”
	CMD [“-p”, “80”]


Podemos crear un contenedor a partir de la imagen generada:
docker run centos:centos7: Se creará el contenedor con el servidor web escuchando en el puerto 80.
docker run centos:centros7 -p 8080: Se creará el contenedor con el servidor web escuchando en el puerto 8080.
