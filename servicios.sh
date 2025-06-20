#!/bin/bash

servicios=("ssh" "cron" "nginx") #lista de servicios que se trabajaran

for servicio in "${servicios[@]}"; do #se recorrera los servicios en la lista
	systemctl is-active --quiet $servicio #se verificara si el servicio esta activo

	if [ $? -ne 0 ]; then # si esta inactivo (status diferente de 0)
		echo "Heyyy tu el que estas viendo esto, !el servicio $servicio esta detenido o caido, se esta tratando de reiniciar"
	else
		echo "todo ta bien =)"
	fi
done
