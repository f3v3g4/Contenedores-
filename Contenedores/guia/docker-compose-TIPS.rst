Que es Credicard Pago
===================


Esta creado con docker compose

# docker images
REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE
credicard-paguetodo   latest              6977a64682a3        4 months ago        456MB

# cat docker-compose.yml
version: '3'
services:
  api:
    container_name: credicard-paguetodo-prod
    image: credicard-paguetodo:latest
    command:  java -Xms2048m -Xmx2048m -Djava.awt.headless=true -Dcom.ibm.as400.access.AS400.guiAvailable=false -Dhttp.proxyHost=10.132.0.10 -Dhttp.proxyPort=8080 -Dhttps.proxyHost=10.132.0.10 -Dhttps.proxyPort=8080 -jar credicard-paguetodo.jar server config.yml prod true
    # command:  java -Djava.awt.headless=true -Dcom.ibm.as400.access.AS400.guiAvailable=false -jar credicard-paguetodo.jar server config.yml prod true
    restart: always
    network_mode: "host"
    extra_hosts:
      - "api.credicard.com.ve:10.133.0.142"
    ports:
      - "29436:29436"
      - "8443:8443"
    volumes:
      - /apisis/log:/usr/app/log/
      - /apisis/Entrada/:/usr/app/Entrada/

# cat restart.sh
#!/bin/bash
docker-compose -f /home/mrodrige/docker-compose.yml restart

# cat backup.sh
#!/bin/bash
name="credicard-paguetodo"
docker save $name:latest | gzip > /home/mrodrige/backup.tar.gz

# cat backup.sh
#!/bin/bash
name="credicard-paguetodo"
docker save $name:latest | gzip > /home/mrodrige/backup.tar.gz
[root@lcsprdappapiserver1 bin]# cat load.sh
#!/bin/bash
docker-compose -f /home/mrodrige/docker-compose.yml up -d --no-deps --build
docker image prune -f

# cat rollback.sh
#!/bin/bash
DIR="/home/mrodrige"
name="backup"
file=$DIR/$name.tar.gz
docker load < $file
docker-compose -f /home/mrodrige/docker-compose.yml up -d --no-deps --build
docker image prune -f
docker logs -f credicard-paguetodo-prod --tail 100

# cat full-load.sh
#!/bin/bash
DIR="/home/mrodrige"
name="credicard-paguetodo"
file=$DIR/$name.tar.gz
docker save $name:latest | gzip > $DIR/backup.tar.gz
docker load < $file && rm $file
docker-compose -f /home/mrodrige/docker-compose.yml up -d --no-deps --build
docker image prune -f
docker logs -f credicard-paguetodo-prod --tail 100

# cat logs.sh
#!/bin/bash
docker logs -f credicard-paguetodo-prod --tail 100

lcsprdappapiserver1
172.18.0.1
172.17.0.1
10.133.0.166 
