#!/bin/bash

#Esrte script se encarga de ejecutar remotamente algun script implementado en este proyecto  (u otro script)
#en diferentes equipos definidos en 'ips.txt'

# Verificamos que se reciban 3 argumentos: usuario, script y archivo con IPs/hosts
if [ "$#" -ne 3 ]; then
  echo "Uso: $0 <usuario> <script.sh> <ips.txt>"
  echo "Ejemplo: $0 jdope respaldo.sh ips.txt"
  exit 1
fi

#Convertimos los parametros en variables para usarlos de forma mas facil dentro del script
Usuario="$1"     
Script="$2"      
Archivo="$3"

# Verificamos que el script exista en el equipo
if [ ! -f "$Script" ]; then
  echo "Error: El archivo '$Script' no existe."
  exit 1
fi

# Verificamos que el archivo 'ips.txt' exista
if [ ! -f "$Archivo" ]; then
  echo "Error: El archivo '$Archivo' no existe o tiene un fallo"
  exit 1
fi

#Confirmacion de que recibimos los dos archivos anteriores
echo "Archivos verificados. Ejecutando '$Script' en los hosts de '$Archivo"

#(Si no existe) creamos el directorio donde se almacenan los reportes
mkdir -p Reportes

#Se analiza cada linea de 'ips.txt' en un bucle while donde se ejecuta en cada equipo
while IFS= read -r IP; do #IFS es un comando interno que analiza linea por linea un archivo (en este caso 'ips.txt')
  echo "Analizando host: $IP"

  #Si hay una linea vacia, la saltamos
  if [ -z "$IP" ]; then
    echo "Línea vacía. Saltando a la siguiente, se espera una IP"
    continue
  fi

  #Creamos un nombre de log único por host + fecha (ej: 192.168.1.190_2025-06-23_01-45.log)
  FechaLog=$(date +%Y-%m-%d_%H-%M)
  Log="Reportes/${IP}_${FechaLog}.log"

  #Escribimos el contenido del log
  echo "🖥️ Log de ejecución remota para $IP" > "$Log"
  echo "🕒 Fecha: $(date '+%Y-%m-%d %H:%M:%S')" >> "$Log"

  #Copiamos el script al host remoto, en la carpeta temporal /tmp (ya que tmp borrara todo aquel contenido automaticamente en este directorio)
  echo "Copiando $Script a $IP" | tee -a "$Log"
  scp "$Script" "$Usuario@$IP:/tmp/" >> "$Log" 2>&1 #Redirecciona a la salida estandar de errores y asegura que tambien se ubique en el log
  if [ $? -ne 0 ]; then
    echo "Falló la copia a $IP" | tee -a "$Log"
    continue
  fi

  # Ejecutamos el script remotamente
  echo "Ejecutando script en $IP" | tee -a "$Log"
  ssh "$Usuario@$IP" "bash /tmp/$(basename "$Script")" >> "$Log" 2>&1 
  if [ $? -eq 0 ]; then
    echo "✅ Script ejecutado correctamente en $IP" | tee -a "$Log"
  else
    echo "⚠️ Hubo errores durante la ejecución en $IP" | tee -a "$Log"
  fi

  # Marcamos fin de log
  echo "Finalizado $IP" | tee -a "$Log"
  echo "---------------------------------------------" >> "$Log"

done < "$Archivo"
