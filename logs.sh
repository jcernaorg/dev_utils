#!/bin/bash
# logs.sh - Empaqueta logs y limpia antiguos
# Uso: ./logs.sh [dias_para_limpiar]

LOGS_DIR="/var/log"
LARAVEL_LOG="/var/www/cread_front/storage/logs"
DESTINO="/var/backups/cread/logs"
DIAS_LIMPIEZA=${1:-14}
FECHA=$(date +"%Y-%m-%d")

mkdir -p "$DESTINO"

# Empaquetar logs
TARFILE="$DESTINO/logs_$FECHA.tar.gz"
tar -czf "$TARFILE" \
  "$LOGS_DIR/nginx" \
  "$LOGS_DIR/php8.1-fpm.log" \
  "$LARAVEL_LOG"

echo "Logs empaquetados en $TARFILE"

# Limpiar logs antiguos
find "$DESTINO" -name "*.tar.gz" -mtime +$DIAS_LIMPIEZA -exec rm {} \;

exit 0 