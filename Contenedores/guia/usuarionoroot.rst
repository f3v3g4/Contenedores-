Administrar Docker como un usuario no root
=========================================

El demonio de Docker se une a un socket Unix en lugar de a un puerto TCP. Por defecto, ese socket Unix es propiedad del usuario root y otros usuarios solo pueden acceder a él usando sudo. El demonio de Docker siempre se ejecuta como usuario root.

Si no desea preceder el comando docker con sudo, cree un grupo Unix llamado docker y agréguele usuarios. Cuando se inicia el demonio de Docker, crea un socket Unix al que pueden acceder los miembros del grupo de Docker.

**Advertencia**

El grupo de Docker otorga privilegios equivalentes a los del usuario root. Para obtener detalles sobre cómo esto afecta la seguridad en su sistema, consulte Superficie de ataque del demonio de Docker.

**Nota:**

Para ejecutar Docker sin privilegios de root, consulte Ejecutar el demonio de Docker como usuario no root (modo sin root).

Para crear el grupo de Docker y agregar su usuario:

Cree el grupo de Docker.::
	
	$ sudo groupadd docker

Agregue su usuario al grupo de Docker.::

	$ sudo usermod -aG docker $USER

Cierre la sesión y vuelva a iniciarla para que se vuelva a evaluar la membresía de su grupo.

Si realiza la prueba en una máquina virtual, puede ser necesario reiniciar la máquina virtual para que los cambios surtan efecto.

En un entorno de escritorio Linux como X Windows, cierre la sesión por completo y luego vuelva a iniciarla.

En Linux, también puede ejecutar el siguiente comando para activar los cambios en los grupos::

	$ newgrp docker 

Verifique que pueda ejecutar comandos de Docker sin sudo.::

	$  docker run hello-world
