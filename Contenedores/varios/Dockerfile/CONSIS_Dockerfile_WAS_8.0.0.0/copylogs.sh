#!/bin/bash

echo "Iniciando el script de copy logs"
while true
do
    sleep 10
    if [ -f /opt/IBM/WebSphere/profiles/D9080/acsele.log ] ; then
        cp /opt/IBM/WebSphere/profiles/D9080/acsele.log /scm/logs
    fi
done
