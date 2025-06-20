#!/bin/bash

TOKEN="7862071230:AAGkPBjaXhVQqp6daSTrFOhrxmHny-ll17Q" #los datos del telegram
CHAT_ID="-1002891538692"

servicios=("ssh" "cron" "nginx") #lista de servicios que se trabajaran

for servicio in "${servicios[@]}"; do #se recorrera los servicios en la lista
	systemctl is-active --quiet $servicio #se verificara si el servicio esta activo

	if [ $? -ne 0 ]; then # si esta inactivo (status diferente de 0)
		echo "Heyyy tu el que estas viendo esto, !el servicio $servicio esta detenido o caido, se esta tratando de reiniciar"
		systemctl restart $servicio
		sleep 1

		systemctl is-active --quiet $servicio

		if [ $? -eq 0 ]; then
		echo " onni-chan el servicio $servicio se reiniciooo"
		else
		echo "sempai el servicio  $servicio no c pudo reiniar"
		fi
	else
		echo " el servicio esta funcionando bien"
	fi

