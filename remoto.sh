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

# Transferir el script al servidor remoto con scp
echo " Copiandoel '$criptT' al servidor remoto..."
scp "$Script" "$Usuario@$IP:/tmp/" || {
  echo " Error durante la copia con scp."
  exit 1
}

#Confirmacion de que funcionan lso dos archivos
echo "Archivos verificados, haciendo la ejecucion remota de $Script"

# Ejecutar el script remotamente con ssh
echo " Ejecutando '$cript' en el servidor remoto..."
ssh "$Usuario@$IP" "bash /tmp/$(basename "$Script")"
