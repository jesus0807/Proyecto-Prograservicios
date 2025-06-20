EXPLICACION DEL SCRIPT "SERVICIOS.SH"

Este script tiene como objetivo monitorear de forma automaticamente algunos de los servicios de linux (ssh cron nginx), la cual detectara si alguno de estos esta "INACTIVO", siendo asi, que se tendra que reiniciar de forma automaticamente.

A continuacion se seguira con las instruccione que el profesor propuso para este script
----------------------------------------------------------------------------------------
servicios.sh
• Debe revisar el estado de servicios definidos en una lista.
• Si un servicio está inactivo, debe intentar iniciarlo.
• Debe registrar los servicios caídos e informar por Telegram.
-----------------------------------------------------------------------------------------

Continuando con el monitoreo del servicio, el mismo script tendra la funcion de poder enviar un mensaje a Telegram, donde informara el servicio que se estubo monitoreando, y dira que se(detuvo/callo) pero se reinicio.
