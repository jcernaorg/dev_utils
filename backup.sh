#!/bin/bash
# backup.sh - Copia de seguridad diaria del código, base de datos y .env
# Uso: programar en cron para ejecución diaria

# Configuración
PROYECTO="/var/www/cread_front"
DESTINO="/var/backups/cread"
DIAS_ROTACION=7
USUARIO_REMOTO="usuario@servidor_remoto"
RUTA_REMOTA="/ruta/remota/backups/cread"
ENV_PATH="$PROYECTO/.env"

# Leer variables del .env
DB_NAME=$(grep DB_DATABASE $ENV_PATH | cut -d '=' -f2)
DB_USER=$(grep DB_USERNAME $ENV_PATH | cut -d '=' -f2)
DB_PASS=$(grep DB_PASSWORD $ENV_PATH | cut -d '=' -f2)

FECHA=$(date +"%Y-%m-%d")
ARCHIVO="cread_backup_$FECHA.tar.gz"

mkdir -p "$DESTINO"

# Backup base de datos
mysqldump -u$DB_USER -p$DB_PASS $DB_NAME > "$DESTINO/db_$FECHA.sql"

# Backup archivos
cd "$PROYECTO"
tar --exclude="node_modules" --exclude="vendor" -czf "$DESTINO/$ARCHIVO" . "$DESTINO/db_$FECHA.sql"

# Eliminar SQL temporal
rm "$DESTINO/db_$FECHA.sql"

# Rotación de backups
find "$DESTINO" -name "*.tar.gz" -mtime +$DIAS_ROTACION -exec rm {} \;

# Subida remota (ejemplo con scp)
scp "$DESTINO/$ARCHIVO" "$USUARIO_REMOTO:$RUTA_REMOTA/"
# O con rclone:
# rclone copy "$DESTINO/$ARCHIVO" remote:$RUTA_REMOTA/

exit 0 