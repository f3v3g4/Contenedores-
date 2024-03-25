# Utilizando CentOS 7 para la base de la imagen
FROM centos:7

MAINTAINER Carlos Gomez G cgomeznt@gmail.com

# Declaramos las siguientes variables por recomendaciones d Docker
ENV     container docker

# Instalamos paquetes necesarios para la base que nos permitan administrar y hacer troubleshooting
RUN     yum -y update && \
        yum -y install sudo \
        tar \
        gzip \
        openssh-clients \
        vi \
        find \
	net-tools \
	zip \
	unzip \
	ld-linux.so.2 \
	libgcc.i686 && \
	yum clean all && \
	mkdir /scm

# Creamos este volumen que nos permite modificar, eliminar o agregar archivos y/o directorios luego que el CONTENEDOR este en uso.
VOLUME  "/scm"
