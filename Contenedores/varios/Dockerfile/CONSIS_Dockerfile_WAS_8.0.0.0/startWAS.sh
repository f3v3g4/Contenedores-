#!/bin/bash

nohup /scm/scripts/copylogs.sh > /scm/logs/copylogs.log &
echo "Borrando el cache...!!!"
rm -rf /opt/IBM/WebSphere/profiles/D9080/wstemp/*
echo "Borrando los temp...!!!"
rm -rf /opt/IBM/WebSphere/profiles/D9080/temp/*
echo "Borrando acsele.log"
if [ -f /opt/IBM/WebSphere/profiles/D9080/acsele.log ] ; then
    echo " " >  /opt/IBM/WebSphere/profiles/D9080/acsele.log
fi
echo "Iniciando el Weblogic....!!!"
echo " " 
/opt/IBM/WebSphere/profiles/D9080/bin/startServer.sh server1
echo " " 
echo "El WAS ya esta iniciado en background"
echo "Para ver los logs, busque en esta ruta:"
echo "/u01/scm/logs/"

