#!/bin/bash

# Los datos del bot de telegram
source /home/irvin/GitHub/Proyecto-Prograservicios/config.txt 

servicios=("ssh" "cron" "nginx") #lista de servicios que se trabajaran

mensaje_telegram() { #funcionamiento para enviar las notificaciones
	local mensaje="$1"

	curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
		-d chat_id="$CHAT_ID" \
		-d text="$mensaje"
}

# Butle principal
for servicio in "${servicios[@]}"; do #se recorrera los servicios en la lista
	systemctl is-active --quiet $servicio #se verificara si el servicio esta activo

	if [ $? -ne 0 ]; then # si esta inactivo (status diferente de 0) el servicio esta detendio
		echo "Heyyy tu el que estas viendo esto, !el servicio $servicio esta detenido o caido, se esta tratando de reiniciar"
		systemctl restart "$servicio" #intenta reiniciar el servicio
		sleep 1 # espera breve para el reinicio para el efecto

		systemctl is-active --quiet "$servicio" # verifica nuevamente si el servicio se activo

		if [ $? -eq 0 ]; then # salta un mensaje se c reinico 
		mensaje=" onni-chan el servicio $servicio se detubo o cayo, pero se reiniciooo"
		echo "$mensaje"
		else
		mensaje "sempai el servicio  $servicio no c pudo reiniar" # salta el mensaje si no c pudo reinicia
		echo "$mensaje"
		fi

		mensaje_telegram "$mensaje" # envia el mensaje a telegram

	else
		echo " el servicio esta funcionando bien"
	fi
done
