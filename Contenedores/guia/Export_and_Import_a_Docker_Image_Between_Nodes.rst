Export and Import a Docker Image Between Nodes
==================================================

One of the driving forces behind Docker is to create a consistent environment across all Docker enabled machines and to create portable templates, or images, which can be ran on any Docker enabled server.

It would, therefore, make perfect sense that Docker have made it very easy for us to export a running container and re-import it on another Docker server.


Find the ID of the container that you would like to move.::

	$ docker ps -a
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
	f4b0d7285fec        ubuntu:14.04        /bin/bash           38 minutes ago      Exit 0                                  hungry_thompson
	8ae64c0faa34        ubuntu:14.04        /bin/bash           41 minutes ago      Exit 0                                  jovial_hawking
	3a09b2588478        ubuntu:14.04        /bin/bash           45 minutes ago      Exit 0                                  kickass_lovelace


I’m going to use the above 3a09b2588478 ID for this example.

Commit your changes and save the container to an image called mynewimage.::

	$ docker commit 3a09b2588478 mynewimage
	4d2eab1c0b9a13c83abd72b38e5d4b4315de3c9967165f78a7b817ca99bf191e


Save the mynewimage image to a tar file. I will use the /tmp/ directory to save the image but you could easily use a NFS share to make it easier to move the completed tar file.::


	$ docker save mynewimage > /tmp/mynewimage.tar

Copy the mynewimage.tar file to your new Docker instance using whatever method works in your environment, for example FTP, SCP, etc.

Run the docker load command on your new Docker instance and specify the location of the image tar file.::

	$ docker load < /tmp/mynewimage.tar


Finally, run the docker images command to check that the image is now available.::

	$ docker images
	REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
	mynewimage          latest              4d2eab1c0b9a        5 minutes ago       278.1 MB
	ubuntu              14.04               ad892dd21d60        11 days ago         275.5 MB
	<none>              <none>              6b0a59aa7c48        11 days ago         169.4 MB
	<none>              <none>              6cfa4d1f33fb        7 weeks ago         0 B


