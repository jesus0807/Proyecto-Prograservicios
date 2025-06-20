EXPLICACION DEL SCRIPT "SERVICIOS.SH"

Este script tiene como objetivo monitorear de forma automaticamente algunos de los servicios de linux (ssh cron nginx), la cual detectara si alguno de estos esta "INACTIVO", siendo asi, que se tendra que reiniciar de forma automaticamente.

A continuacion se seguira con las instruccione que el profesor propuso para este script
----------------------------------------------------------------------------------------
servicios.sh
• Debe revisar el estado de servicios definidos en una lista.
• Si un servicio está inactivo, debe intentar iniciarlo.
• Debe registrar los servicios caídos e informar por Telegram.
