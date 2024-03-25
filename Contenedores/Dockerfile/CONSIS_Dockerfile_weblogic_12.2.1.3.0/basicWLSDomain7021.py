print 'Iniciando el proceso desasistido de la instalacion de Weblogic 12.2.1.3.0'


readTemplate("/u01/app/oracle/middleware/wlserver/common/templates/wls/wls.jar")

print 'Creando el puerto por el 7021'
cd('Servers/AdminServer')
set('ListenAddress','')
set('ListenPort', 7021)

print 'Creando el usuario weblogic y asignandole la clave'
cd('/')
cd('Security/base_domain/User/weblogic')
cmo.setPassword('weblogic01')


print 'Creating Domain...!!!'
writeDomain('/u01/app/oracle/middleware/user_projects/domains/D7021')


closeTemplate()

print 'Culminado el proceso de creacion de Dominio para Weblogic'
exit()
