#!/bin/bash
# ssl_renovar.sh - Fuerza renovación de SSL y recarga Nginx
# Uso: programar en cron mensual

EMAIL="admin@cread.org.pe"
LOG="/var/log/ssl_renovar.log"

certbot renew --quiet --deploy-hook "systemctl reload nginx" > "$LOG" 2>&1
if [ $? -ne 0 ]; then
  mail -s "[ALERTA] Fallo renovación SSL en CREAD" "$EMAIL" < "$LOG"
fi

exit 0 