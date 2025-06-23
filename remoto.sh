#!/bin/bash

# Verificar que se reciban 3 argumentos
if [ "$#" -ne 3 ]; then
  echo "Uso: $0 <usuario> <IP_remota> <script.sh>"
  echo "Ejemplo: $0 jdope 192.168.1.100 respaldo.sh"
  exit 1
fi

# Hacemos variables a los argumentos
Usuario="$1"
IP="$2"
Script="$3"

# Verificar que el archivo de script exista localmente
if [ ! -f "$Script" ]; then
  echo "Error: El archivo '$Script' no existe."
  exit 1
fi

# Transferir el script al servidor remoto con scp
echo " Copiandoel '$criptT' al servidor remoto..."
scp "$Script" "$Usuario@$IP:/tmp/" || {
  echo " Error durante la copia con scp."
  exit 1
}

# Ejecutar el script remotamente con ssh
echo " Ejecutando '$cript' en el servidor remoto..."
ssh "$Usuario@$IP" "bash /tmp/$(basename "$Script")"
