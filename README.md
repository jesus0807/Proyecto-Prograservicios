## Proyecto Final - Programación para la Administración de Servicios.
## Miembros del equipo:
1. **Christopher Gomez Mendoza**
2. **Jesus Valentín Flandes Hernandez**
3. **Mario Erik Flandes Hernandez**
4. **Irvin Josafat Domínguez Morales**


## Objetivo del proyecto.
Desarrolar e implementar diferentes Scripts en Bash para facilitar o automatizar tareas de Sysadmin en servidores basados en Linux, tales como la  gestion de usuarios, respaldos de directorios, monitoreo de equipo, controles de servicios y ejecuciones remotas.
Todo enlazado a un bot de la aplicaicon de Telegram que notifica de manera autonoma y en tiempo real lo que sucede en el sistema. 

## Scripts implementados.
- **`usuarios.sh`**: Gestiona altas, bajas y modificaciones de usuarios. Registra acciones en logs y envía alertas por Telegram.
- **`respaldo.sh`**: Automatiza el respaldo de directorios específicos utilizando `tar` y `cron`. Envíando una notificación al finalizar.
- **`monitoreo.sh`**: Supervisa el uso de CPU y disco. Si se superan ciertos umbrales, alerta por Telegram.
- **`servicios.sh`**: Verifica si servicios críticos están activos. Si no, intenta reiniciarlos y avisa.
- **`remoto.sh`**: Copia scripts a múltiples hosts remotos usando `scp` y los ejecuta con `ssh`. Genera reporte por host.

## config.txt
Importante: Crea tu propio config.txt a partir del archivo config.example.txt y completa tus datos reales antes de ejecutar los scripts.
