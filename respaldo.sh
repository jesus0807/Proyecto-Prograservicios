#!/bin/bash

#Este script se encarga de comprimir un directorio y notificar por Telegram

#Establecemos PATH para el uso correcto de cron
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#Cargamos  las configuraciones 
source /home/jdope/Proyecto_Adm.Servicios/Proyecto-Prograservicios/config.txt

#Convertimos la fecha y el archivo respaldo en variables para resumirlos y que sea mas facil usarlos
Fecha=$(date +%Y-%m-%d_%H:%M)
Archivo_respaldado="$Directorio_respaldado/respaldo_$Fecha.tar.gz"

#Debugeo de rutas (para probar que sean obtenidas del config.txt correctamente)
echo "Directorio a respaldar [$Directorio_a_respaldar]"
echo "Directorio respaldado [$Directorio_respaldado]"
echo "Archivo resultante: [$Archivo_respaldado]"

#En caso de que no exita el directorio destino, esta linea se encarga de crearlo para evitar errores en caso de
#que no se haya definido correctamente en config.txt
mkdir -p "$Directorio_respaldado"

#Se crea el respaldo
echo "Creando el respaldo..."
tar -czf "$Archivo_respaldado" "$Directorio_a_respaldar"

#if para verificar si se hizo el respaldo correctamente
if [[ -f "$Archivo_respaldado" ]]; then
    Mensaje_para_bot="✅ Respaldo exitoso de $Archivo_respaldado con fecha:$Fecha"
else
    Mensaje_para_bot="⚠️ Error: Ocurrio un fallo al crear el respaldo"
fi

# Enviar notificación
/usr/bin/curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
  -d chat_id="$CHAT_ID" \
  -d text="$Mensaje_para_bot"

#Bitacora al .log
echo "[$(date '+%Y-%m-%d %H:%M')] Respaldado $Directorio_a_respaldar -> $Archivo_respaldado" >> /home/jdope/respaldo.log

