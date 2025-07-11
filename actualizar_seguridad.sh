#!/bin/bash
# actualizar_seguridad.sh - Actualiza solo el kernel y programa reboot
# Uso: ejecutar manualmente o por cron

apt-get update
apt-get --just-kernel upgrade -y

# Programar reboot si es necesario
if [ -f /var/run/reboot-required ]; then
  echo "Reboot programado en 2 minutos..."
  shutdown -r +2
fi

exit 0 