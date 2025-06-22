#!/bin/bash

#Este script se encargara de comprimir un directorio en especifico segun este programado su respaldo

#Configuracion base
source config.txt
#Convertimos la fecha en un avariable para un manejo mas facil de esta
Fecha=$(date +%Y-%m-%d_%H-%M)
#Nombre del archivo respaldo
Archivo_respaldado="$Directorio_respaldado/respaldo_$Fecha.tar.gz"

#Creacion del respaldo
echo "Creando el respaldo de $Directorio_a_respaldar a $Archivo_respaldado"
tar -cfz "$Archivo_respaldado" "$Directorio_a_respaldar"

#if para verificar que se creo el respaldo
if [ -f "$Archivo_respaldado" ]; then
	Mensaje_para_bot="Se a llevado acabo el respaldo al directorio $Directorio_a_respaldar con exito"
else
	Mensaje_para_bot="Ocurrio un error al tratar de hacer el respaldo del directorio $Directorio_a_respaldar ⚠️"
fi

#Mensaje a Telegram
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d text="$Mensaje_para_bot"
