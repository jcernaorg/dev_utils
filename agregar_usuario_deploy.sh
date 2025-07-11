#!/bin/bash
# agregar_usuario_deploy.sh - Crea usuario deploy y configura SSH
# Uso: ./agregar_usuario_deploy.sh llave.pub

if [ -z "$1" ]; then
  echo "Uso: $0 llave_ssh.pub"
  exit 1
fi

useradd -m -s /bin/bash deploy
mkdir -p /home/deploy/.ssh
cat "$1" >> /home/deploy/.ssh/authorized_keys
chmod 700 /home/deploy/.ssh
chmod 600 /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh

# Limitar permisos
usermod -L root
usermod -aG www-data deploy

exit 0 