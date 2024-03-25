#!/bin/bash

echo "Deteniendo el Weblogic....!!!"
/u01/app/oracle/middleware/user_projects/domains/D7021/bin/stopWebLogic.sh
rm -rf /u01/app/oracle/middleware/user_projects/domains/D7021/servers/AdminServer/cache/*
rm -rf /u01/app/oracle/middleware/user_projects/domains/D7021/servers/AdminServer/tmp/*
