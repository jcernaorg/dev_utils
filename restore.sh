#!/bin/bash
# restore.sh - Restaura una copia de seguridad
# Uso: ./restore.sh archivo_backup.tar.gz

if [ -z "$1" ]; then
  echo "Uso: $0 archivo_backup.tar.gz"
  exit 1
fi

ARCHIVO="$1"
PROYECTO="/var/www/cread_front"
ENV_PATH="$PROYECTO/.env"

# Leer variables del .env
DB_NAME=$(grep DB_DATABASE $ENV_PATH | cut -d '=' -f2)
DB_USER=$(grep DB_USERNAME $ENV_PATH | cut -d '=' -f2)
DB_PASS=$(grep DB_PASSWORD $ENV_PATH | cut -d '=' -f2)

# Extraer backup
mkdir -p /tmp/cread_restore
cd /tmp/cread_restore
tar -xzf "$ARCHIVO"

# Restaurar storage
rm -rf "$PROYECTO/storage"
mv storage "$PROYECTO/"

# Restaurar base de datos
mysql -u$DB_USER -p$DB_PASS $DB_NAME < db_*.sql

# Limpiar
rm db_*.sql
cd ~
rm -rf /tmp/cread_restore

# Reiniciar servicios
systemctl restart nginx
systemctl restart php8.1-fpm

exit 0 