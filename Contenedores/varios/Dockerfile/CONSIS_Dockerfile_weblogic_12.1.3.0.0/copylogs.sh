#!/bin/bash

echo "Iniciando el script de copy logs"
while true
do
    sleep 10
    if [ -f /u01/app/oracle/middleware/user_projects/domains/D7021/acsele.log ] ; then
        cp /u01/app/oracle/middleware/user_projects/domains/D7021/acsele.log /scm/logs
    fi
done
