#!/bin/bash

archivo_config="config.txt"
archivo_log="usuarios.log"

accion="$1"
nombre1="$2"
nombre2="$3"

source <(grep -E '^[A-Z_]+=.*' "$archivo_config")
token="$TOKEN"
chat_id="$CHAT_ID"

enviar_mensaje() {
  curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
    -d "chat_id=$chat_id" \
    -d "text=$1"
}

guardar_log() {
  echo "$(date '+%F %T') - $1" >> "$archivo_log"
}

# Validar nombre1 (requerido para todas)
if [[ -z "$nombre1" ]]; then
  mensaje="No se proporcionó el nombre del usuario"
  enviar_mensaje "$mensaje"
  guardar_log "$mensaje"
  exit 1
fi

# Ejecutar según la acción
if [[ "$accion" == "crear" ]]; then
  if sudo useradd "$nombre1" 2>> "$archivo_log"; then
    mensaje="Usuario $nombre1 creado correctamente"
  else
    mensaje="No se pudo crear el usuario $nombre1"
  fi

elif [[ "$accion" == "eliminar" ]]; then
  if sudo userdel "$nombre1" 2>> "$archivo_log"; then
    mensaje="Usuario $nombre1 eliminado correctamente"
  else
    mensaje="No se pudo eliminar el usuario $nombre1"
  fi

elif [[ "$accion" == "modificar" ]]; then
  if [[ -z "$nombre2" ]]; then
    mensaje="No se proporcionó el nuevo nombre para modificar el usuario"
  elif sudo usermod -l "$nombre2" "$nombre1" 2>> "$archivo_log"; then
    mensaje="Usuario $nombre1 cambiado a $nombre2"
  else
    mensaje="No se pudo modificar el usuario $nombre1"
  fi

else
  mensaje="La acción $accion no es válida"
fi

enviar_mensaje "$mensaje"
guardar_log "$mensaje"
