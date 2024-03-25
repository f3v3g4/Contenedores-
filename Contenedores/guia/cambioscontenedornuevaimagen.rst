Guardar los cambios del contenedor en una nueva imagen
================================================

Guardar el estado actual de un contenedor en una nueva imagen.

Vamos instanciar un contenedor, vamos a consultar cual imagen tenemos o queremos::

	$ sudo docker images

Creamos el contenedor::

	$ sudo docker run -dti --name "contenedor-demostracion1" "imagen-demostracion:1.0"

Ingresamos al contenedor para crear un directorio y tener evidencia que modificamos el contenedor::

	$ docker exec -i -t contenedor-demostracion1 /bin/bash
	[root@819fa284fbb2 /]# mkdir /00000

Detenemos el contenedor.
Lo iniciamos nuevamente e ingresamos dentro de él y veremos que aun están los cambios.
Nos salimos del contenedor y lo detenemos.
Consultamos todos los contenedores en Estatus=exited <sudo docker ps -f "status=exited">
Eliminamos el contenedor.
Instanciamos nuevamente en el contenedor e ingresamos y ahora si podemos darnos cuenta que la carpeta no existe.

Guardar el estado actual de un contenedor en una nueva imagen
+++++++++++++++++++++++++++++++++++++++++

Recuerde esta sintaxis < docker commit NOMBRECONTENEDO_O_ID NUEVAIMAGEN:TAG

::

	$ sudo docker commit contenedor-demostracion1 myimagen:2.0

Consultamos que ciertamente este la imagen creada::

	$ sudo docker images

De esta nueva imagen creamos un contenedor::

	$ sudo docker run -dti --name "mycontenedor" "myimagen:2.0"

Validamos que este instanciado el contenedor::

	$ sudo docker ps

Ingresamos y vemos que tiene nuestros cambios::

	$ sudo docker exec -i -t mycontenedor /bin/bash
	[root@4682711eb679 /]# ls

