#!/bin/bash

archivo_config="config.txt"
source <(grep -E '^[A-Z_]+=.*' "$archivo_config")

token="$TOKEN"
archivo_estado="estado.txt"
ultimo_id=0

while true; do
  respuesta=$(curl -s "https://api.telegram.org/bot$token/getUpdates?offset=$((ultimo_id + 1))")
  echo "$respuesta" > ultima_respuesta.json

  if echo "$respuesta" | jq -e '.result' >/dev/null; then
    echo "$respuesta" | jq -c '.result[]' | while read -r mensaje; do
      tipo=$(echo "$mensaje" | jq -r 'if .message then "texto" elif .callback_query then "boton" else empty end')

      if [[ "$tipo" == "texto" ]]; then
        texto=$(echo "$mensaje" | jq -r '.message.text')
        es_bot=$(echo "$mensaje" | jq -r '.message.from.is_bot')
        chat_id=$(echo "$mensaje" | jq -r '.message.chat.id')

        if [[ "$es_bot" == "false" ]]; then
          if [[ "$texto" == "/menu" ]]; then
            curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
              -H "Content-Type: application/json" \
              -d "{
                \"chat_id\": \"$chat_id\",
                \"text\": \"Selecciona una acción:\",
                \"reply_markup\": {
                  \"inline_keyboard\": [
                    [{\"text\": \"Crear usuario\", \"callback_data\": \"crear\"}],
                    [{\"text\": \"Eliminar usuario\", \"callback_data\": \"eliminar\"}],
                    [{\"text\": \"Modificar usuario\", \"callback_data\": \"modificar\"}]
                  ]
                }
              }"
          elif [[ -f "$archivo_estado" ]]; then
            estado=$(cat "$archivo_estado")
            accion=$(echo "$estado" | cut -d':' -f1)
            chat_guardado=$(echo "$estado" | cut -d':' -f2)

            if [[ "$chat_id" == "$chat_guardado" ]]; then
              if [[ "$accion" == "crear" || "$accion" == "eliminar" ]]; then
                ./usuarios.sh "$accion" "$texto"
                rm -f "$archivo_estado"
              elif [[ "$accion" == "modificar1" ]]; then
                echo "modificar2:$chat_id:$texto" > "$archivo_estado"
                curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
                  -d "chat_id=$chat_id" \
                  -d "text=Escribe el nuevo nombre del usuario"
              elif [[ "$accion" == "modificar2" ]]; then
                nombre_anterior=$(echo "$estado" | cut -d':' -f3)
                ./usuarios.sh "modificar" "$nombre_anterior" "$texto"
                rm -f "$archivo_estado"
              fi
            fi
          fi
        fi
      fi

      if [[ "$tipo" == "boton" ]]; then
        accion=$(echo "$mensaje" | jq -r '.callback_query.data')
        chat_boton=$(echo "$mensaje" | jq -r '.callback_query.message.chat.id')
        id_callback=$(echo "$mensaje" | jq -r '.callback_query.id')

        if [[ "$accion" == "crear" || "$accion" == "eliminar" ]]; then
          echo "$accion:$chat_boton" > "$archivo_estado"
          mensaje_boton="Escribe el nombre del usuario para $accion"
        elif [[ "$accion" == "modificar" ]]; then
          echo "modificar1:$chat_boton" > "$archivo_estado"
          mensaje_boton="Escribe el nombre actual del usuario que quieres cambiar"
        fi

        curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
          -d "chat_id=$chat_boton" \
          -d "text=$mensaje_boton"

        curl -s -X POST "https://api.telegram.org/bot$token/answerCallbackQuery" \
          -d "callback_query_id=$id_callback" > /dev/null
      fi
    done

    ultimo_id=$(echo "$respuesta" | jq '[.result[].update_id] | max')
  fi

  sleep 1
done
