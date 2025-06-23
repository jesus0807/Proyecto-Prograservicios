#!/bin/bash

# Verificar que se reciban 3 argumentos: usuario, script y el archivo con las IP(ips.txt)
if [ "$#" -ne 3 ]; then
  echo "Uso: $0 <usuario> <script.sh> <ips.txt>"
  echo "Ejemplo: $0 jdope respaldo.sh ips.txt"
  exit 1
fi

# Hacemos variables a los argumentos
Usuario="$1"
Script="$2"
Archivo="$3"

# Verificar que el archivo de script exista localmente
if [ ! -f "$Script" ]; then
  echo "Error: El archivo '$Script' no existe."
  exit 1
fi
#Verificar que el archivo con las IP exista
if [ ! -f "$Archivo" ]; then
	echo "Error: el $Archivo no existe o tiene un fallo"
	exit 1
fi

#Confirmacion de que funcionan lso dos archivos
echo "Archivos verificados, haciendo la ejecucion remota de $Script"

#CReamos la carpeta donde se ubicaran los reportes de las ejecuciones remotas
mkdir -p Reportes

#Lee la IP del archivo ips.txt
while IFS= read -r IP; do #IFS avriable que analiza cada linea interna del archivo ips.txt
	echo "Procesando el host con ip: $IP"

	#Verifica si la línea no está vacía si no, seguira buscando
	if [ -z "$IP" ]; then
    		echo "Buscando una IP"
    		continue
  	fi

  	#Copia el script al host remoto
  	scp "$Script" "$Usuario@$IP:/tmp/" 2>> reportes_remotos/$IP.log
  	if [ $? -ne 0 ]; then
    		echo "Falló la copia a $IP" | tee -a reportes_remotos/$IP.log
    		continue
  	fi

  	#Ejecuta el script 
  	echo "Ejecutando script en $IP..."
  	ssh "$Usuario@$IP" "bash /tmp/$(basename "$Script")" >> reportes_remotos/$IP.log 2>&1

  	echo "Finalizado $IP" | tee -a reportes_remotos/$IP.log
	echo "---------------------------------------------" >> reportes_remotos/$IP.log

	#Crea el log del host donde se ejcuta el script
	Log="Reportes/$IP.log"
	echo "🕒 Fecha: $(date '+%Y-%m-%d %H:%M')" > "$Log"
done < "$Archivo" 
