#!/bin/bash
# cambiar_node.sh - Cambia entre versiones de Node.js
# Uso: ./cambiar_node.sh <version>

if [ -z "$1" ]; then
  echo "Uso: $0 <version_node>"
  exit 1
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use $1
npm cache clean --force
node -v

exit 0 