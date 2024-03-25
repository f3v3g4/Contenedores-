#!/bin/bash

nohup /scm/scripts/copylogs.sh > /scm/logs/copylogs.log &
echo "Borrando el cache...!!!"
rm -rf /u01/app/oracle/middleware/user_projects/domains/D7021/servers/AdminServer/cache/*
echo "Borrando los tmp...!!!"
rm -rf /u01/app/oracle/middleware/user_projects/domains/D7021/servers/AdminServer/tmp/*
echo "Borrando acsele.log"
if [ -f /u01/app/oracle/middleware/user_projects/domains/D7021/acsele.log ] ; then
    echo " " >  /u01/app/oracle/middleware/user_projects/domains/D7021/acsele.log /scm/logs
fi
echo "Iniciando el Weblogic....!!!"
echo " " 
nohup /u01/app/oracle/middleware/user_projects/domains/D7021/bin/startWebLogic.sh > /scm/logs/log_start.log
echo " " 
echo "El Weblogic ya esta iniciado en background"
echo "Para ver los logs, busque en esta ruta:"
echo "/u01/scm/logs/"

