#!/bin/bash

servicios=("ssh" "cron" "nginx") #lista de servicios que se trabajaran

for servicio in "${servicios[@]}"; do #se recorrera los servicios en la lista
	systemctl is-active --quiet $servicio #se verificara si el servicio esta activo
	if [ $? -ne 0 ]; then
		echo "Heyyy tu el que estas viendo esto, !el servicio $servicio esta detenido o caido"
	else
		echo "todo ta bien =)"
	fi
done
