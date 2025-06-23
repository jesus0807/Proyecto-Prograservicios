#!/bin/bash

source config.txt  # Carga el archivo donde tiene los parametros reutilizables

if [[ -f offset.txt && -s offset.txt ]]; then # Verificamos que el archivo offset exista y no este vacio si es asi lee el contenido
  idSiguiente=$(cat offset.txt)               # del archivo, si no se cumple alguna se le asigna el valor de 0
else
  idSiguiente=0
fi

respuesta=$(curl -s "https://api.telegram.org/bot$TOKEN/getUpdates?offset=$idSiguiente") # Le pedimos a Telegram los mensajes no leídos a 
                                                                                         # partir de que mensaje


mensaje=$(echo "$respuesta" | grep -o '"text":"[^"]*"' | cut -d':' -f2 | tr -d '"') # Extraemos el texto del ultimo mensaje

ultimo_id=$(echo "$respuesta" | grep -o '"update_id":[0-9]*' | tail -1 | cut -d':' -f2) # Extraemos el update_id del mensaje y lo guardamos
if [[ -n "$ultimo_id" ]]; then                                                          # en el archivo offset para que no se repitan los
  echo $((ultimo_id + 1)) > offset.txt                                                  # mensajes cada que se ejecute el script
fi

url="https://api.telegram.org/bot$TOKEN/sendMessage" # Variable del url del bot


if [[ "$mensaje" == /cpu* ]]; then                                                          # Condicionales para comprobar si el mensaje 
  valor=$(echo "$mensaje" | awk '{print $2}')                                               # recibido es /cpu o /disco y cambiar el valor
  sed -i "s/^limiteCpu=.*/limiteCpu=$valor/" config.txt                                     # en el archivo config.txt y mandar un mensaje de 
  curl -s -X POST $url -d chat_id="$CHAT_ID" -d text="🔧 Limite de CPU cambiado a $valor%"  # que se cambio el limite del cpu o disco respectivamente
fi

if [[ "$mensaje" == /disco* ]]; then
  valor=$(echo "$mensaje" | awk '{print $2}')
  sed -i "s/^limiteDisco=.*/limiteDisco=$valor/" config.txt
  curl -s -X POST $url -d chat_id="$CHAT_ID" -d text="🔧 Limite de Disco cambiado a $valor%"
fi


source config.txt # Cargamos el archivo con los nuevos valores

cpu=$(mpstat 1 1 | awk '/Media/ {print 100 - $NF}' | cut -d'.' -f1) # Obtenemos el numero del cpu utilizado
disco=$(df / | tail -1 | awk '{print $5}' | tr -d '%')              # Obtenemos el espacio ocupado del disco

echo "🧪 Valor de CPU medido: $cpu%"

if [[ "$mensaje" == /estado* ]]; then  # Condicional para ver si el ultimo mensaje es /estado, si es manda el mensaje con los valores 
  curl -s -X POST $url -d chat_id="$CHAT_ID" -d text="📊 Estado del sistema:🧠 CPU: $cpu%       💾 Disco: $disco%"
fi


alerta="" # Inicializamos alerta vacio

if (( cpu > limiteCpu )); then                        # Si cpu es mayor que el limite del cpu guarda en alerta el mensaje de cpu alta
  alerta+="CPU muy alta: $cpu% --> Límite $limiteCpu%\n"
fi

if (( disco > limiteDisco )); then                    # Si disco es mayor que el limite del disco guarda en alerta el mensaje de disco lleno
  alerta+="Disco casi lleno: $disco% --> Límite $limiteDisco%\n"
fi

mensaje=$(echo -e "📊 Estado del sistema:\n🧠 CPU: $cpu% --> límite $limiteCpu%\n💾 Disco: $disco% --> límite $limiteDisco%\n\n☣️ Alertas:\n$alerta")

if [[ -n "$alerta" ]]; then
  curl -s -X POST "$url" -d chat_id="$CHAT_ID" -d text="$mensaje"  # Si alerta no esta vacia entonces manda el mensaje al bot
fi
