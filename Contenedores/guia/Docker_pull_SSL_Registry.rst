Docker pull SSL Registry
========================

Como configurar docker para que se pueda conectar a un Registry que tiene SSL.

Si en el registry tiene configurado el SSL, sería más qu suficiente en el servidor que esta realizando la conexión al registry, configurar la CA publica.

Copiar el certificado de la CA en “/etc/pki/ca-trust/source/anchors/”::

	cp /home/cgomez/ca.crt  /etc/pki/ca-trust/source/anchors/ca-2026.crt



Luego ejecutamos este comando::

	update-ca-trust


Si con lo antes realizado se nos presenta el siguiente error::

	ERROR: failed to solve: 10.134.0.252:4443/ccrnodes1.4: failed to do request: Head "https://10.134.0.252:4443/v2/ccrnodes1.4/manifests/latest": tls: failed to verify certificate: x509: certificate signed by unknown authority

Docker tiene una ubicación adicional que puede utilizar para confiar en la CA del servidor de registro individual. 
Puede colocar el certificado CA en  "/etc/docker/certs.d/<docker registry>/ca.crt". 
Incluya el número de puerto si lo especifica en la etiqueta de la imagen, por ejemplo, en Linux, colocamos 4 ejemplos::

	/etc/docker/certs.d/my-registry.example.com:5000/ca.crt
	/etc/docker/certs.d/10.133.0.236:4443/domain.crt
	/etc/docker/certs.d/10.134.0.14:4443/domain.crt
	/etc/docker/certs.d/10.134.0.252:4443/domain.crt

Es decir, en esta carpeta "/etc/docker/certs.d" creaun un nombre de carpeta con la IP o DNS del Registry y su puerto y luego dentro de esa carpeta 
es que se copia el certificado del Registry.

Si aún no tiene el certificado, puede extraerlo usando openssl. Tenga en cuenta que esto confía implícitamente en lo que el registro diga actualmente 
que es su certificado, lo que lo expone a ataques MitM. Esto puede resultar útil como TOFU (confianza en el primer uso) si no estás en un entorno efímero::

	openssl s_client -showcerts -connect my-registry.example.com:5000 < /dev/null \
	  | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'

Este es otro ejemplo::
	  
	openssl s_client -showcerts -connect 10.133.0.236:4443 < /dev/null \
	  | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > registry.crt
