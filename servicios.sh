#!/bin/bash

TOKEN="7862071230:AAGkPBjaXhVQqp6daSTrFOhrxmHny-ll17Q" #los datos del telegram
CHAT_ID="-1002891538692"

servicios=("ssh" "cron" "nginx") #lista de servicios que se trabajaran

mensaje_telegram() { #funcionamiento para enviar las notificaciones
	local mensaje="$1"
	curl -s -X POST https://api.telegram.org/bot$TOKEN/sendMessage \
		-d chat_id="$CHAT_ID" \
		-d text="$mensaje"
}

for servicio in "${servicios[@]}"; do #se recorrera los servicios en la lista
	systemctl is-active --quiet $servicio #se verificara si el servicio esta activo

	if [ $? -ne 0 ]; then # si esta inactivo (status diferente de 0)
		echo "Heyyy tu el que estas viendo esto, !el servicio $servicio esta detenido o caido, se esta tratando de reiniciar"
		systemctl restart $servicio
		sleep 1

		systemctl is-active --quiet $servicio

		if [ $? -eq 0 ]; then
		mensaje=" onni-chan el servicio $servicio se reinicio, pero se reiniciooo"
		echo "$mensaje"
		else
		mensaje "sempai el servicio  $servicio no c pudo reiniar"
		echo "$mensaje"
		fi

		mensaje_telegram "$mensaje"

	else
		echo " el servicio esta funcionando bien"
	fi
done
