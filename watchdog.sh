#!/bin/bash
# watchdog.sh - Monitorea y reinicia servicios críticos
# Uso: programar en cron cada minuto

SERVICIOS=(nginx php8.1-fpm node)

for SVC in "${SERVICIOS[@]}"; do
  if ! systemctl is-active --quiet $SVC; then
    systemctl restart $SVC
    echo "[$(date)] Reiniciado $SVC" >> /var/log/watchdog.log
  fi
done

exit 0 