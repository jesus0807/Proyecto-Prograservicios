#!/bin/bash

# Carga las variables del archivo config.txt
<<<<<<< HEAD
source "$(dirname "$0")/config.txt" # dirname "$0" : obtienen la ruta donde este hubicado el archivo
=======
source "$(dirname "$0")/config.txt" # dirname : obtienen la ruta donde este hubicado el archivo
>>>>>>> bb6d2c5 (Documentación completa del script)

mensaje_telegram() { #funcion para enviar las notificaciones
	local mensaje="$1" # recibe como un parametro 

# chat_id: del grupo donde se encuentra el bot y el mensaje que se ara llegar a telegram
	curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
		-d chat_id="$CHAT_ID" \
		-d text="$mensaje"
}

# Butle principal
for servicio in "${SERVICIOS[@]}"; do #se recorrera los servicios en la lista, que definimos en la seccion de SERVICIOS en config.txt
	systemctl is-active --quiet $servicio # se verificara si el servicio esta activo

<<<<<<< HEAD
	if [ $? -ne 0 ]; then # si esta inactivo (codigo diferente de 0) se intentara reiniciar
		systemctl restart "$servicio" #  reinicia el servicio, si c cumple la condicion
=======
	if [ $? -ne 0 ]; then # si esta inactivo (status diferente de 0) el servicio esta detendio
		systemctl restart "$servicio" # reinicia el servicio, si c cumple la condicion
>>>>>>> bb6d2c5 (Documentación completa del script)
		sleep 1 # espera 1 segundo para darle tiempo al servicio

		systemctl is-active --quiet "$servicio" # vuelve a verificar si el servicio esta activo ( se reinicio automaticamente)

		if [ $? -eq 0 ]; then # condicion donde el servicio se reinicio automaticamente ( codigo mayor a 0 ) se reinicio exitosamente
		mensaje=" onni-chan el servicio $servicio se detubo o cayo, pero se reiniciooo" # notifica que c reinicio automaticamente
<<<<<<< HEAD
		echo "$mensaje" 
		else # sino logro reiniciar el servicio
		mensaje "sempai el servicio  $servicio no c pudo reiniar" # manda un mensaje donde notifica que no se pudo reinicar
		echo "$mensaje"
		fi # final de la condicion de reinicio

		mensaje_telegram "$mensaje" # envia una notificacion si el servicio se (reinicio/o fallo)
	fi 
done #final del bucle
=======
		echo "$mensaje"
		else # si no logro reiniciar el servicio
		mensaje "sempai el servicio  $servicio no c pudo reiniar" # manda una notificacion donde notifica que no se pudo reinicar
		echo "$mensaje"
		fi # final de la condicion de reinicio

		mensaje_telegram "$mensaje" # envia una notificacion si el servicio se (reinicio/o fallo)

	else
		echo " el servicio esta funcionando bien " #manda un mensaje a la terminal que los servicios estan bien (en el caso que ningun servicio este fallando o se detubo)
	fi
done # final de bucle
>>>>>>> bb6d2c5 (Documentación completa del script)
