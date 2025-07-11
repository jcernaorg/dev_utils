#!/usr/bin/env bash
###############################################################################
# SCRIPT V! @javier_cerna_ menú despliegue Laravel + Nginx + Certbot          #
###############################################################################
set -euo pipefail
GREEN="\033[0;32m"; RED="\033[0;31m"; YELLOW="\033[1;33m"; NC="\033[0m"
SERVICIOS=(nginx php8.2-fpm)

msg() { echo -e "$1$2${NC}"; }
pause() { read -rp "$(msg "$YELLOW" '⏎ para continuar…')" _; }
install_pkgs() { sudo apt install -y "$@"; }

#──────────────────── 0 · APT upgrade ────────────────────
update_system() {
  msg "$GREEN" "--- apt update / upgrade ---"
  sudo apt update -qq && sudo apt upgrade -y && sudo apt autoremove -y
}

#──────────────────── 1 · Git clone ──────────────────────
clone_repo() {
  [[ -d .git ]] && { msg "$YELLOW" "Ya es un repo Git."; return; }
  read -rp "URL https:// o owner/repo: " src
  src="${src%.git}"; [[ $src == http* ]] || src="https://github.com/$src.git"
  read -rp "Carpeta destino [$(basename "${src%.git}")]: " dir
  dir=${dir:-$(basename "${src%.git}")}
  git clone "$src" "$dir" && cd "$dir"
}

#──────────────────── 2 · Git pull ───────────────────────
pull_changes() { [[ -d .git ]] && git pull || msg "$RED" "No es repo Git."; }

#──────────────────── 3 · Composer install ───────────────
ensure_composer() { command -v composer >/dev/null || install_pkgs composer; }
ensure_php_exts() {
  php -m | grep -qi dom     || install_pkgs php8.2-xml
  php -m | grep -qi sqlite3 || install_pkgs php8.2-sqlite3
  sudo systemctl restart php8.2-fpm
}
composer_install() {
  ensure_composer; ensure_php_exts
  [[ -d vendor ]] && msg "$YELLOW" "vendor/ ya existe." && return
  COMPOSER_ALLOW_SUPERUSER=1 composer install --no-interaction --prefer-dist
}

#──────────────────── 4 · npm build ──────────────────────
ensure_node() {
  command -v jq >/dev/null || install_pkgs jq
  local req=$(jq -r '.engines.node //empty' package.json 2>/dev/null || true)
  [[ -z $req || $req == null ]] && return
  local major cur; major=$(grep -oE '[0-9]+' <<<"$req" | head -n1)
  cur=$(command -v node >/dev/null && node -v | grep -oE '[0-9]+' | head -n1 || echo 0)
  ((cur >= major)) && return
  msg "$YELLOW" "Instalando Node $major vía NVM…"
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$HOME/.nvm" && source "$NVM_DIR/nvm.sh"
  nvm install "$major" && nvm alias default "$major"
}
npm_build() { ensure_node; npm install; npm run build; }

#──────────────────── 5 · Caches Laravel ─────────────────
ensure_sqlite() {
  grep -q '^DB_CONNECTION=sqlite' .env 2>/dev/null || return
  local db=$(grep '^DB_DATABASE=' .env | cut -d= -f2-)
  [[ -z $db ]] && db="database/database.sqlite"
  [[ $db != /* ]] && db="$(pwd)/$db"
  [[ -f $db ]] || { mkdir -p "$(dirname "$db")"; touch "$db"; }
}
clean_caches() { ensure_sqlite; php artisan optimize:clear && php artisan config:cache; }

#──────────────────── 6 · Reiniciar servicios ────────────
restart_services() { for s in "${SERVICIOS[@]}"; do sudo systemctl restart "$s"; done; }

#──────────────────── 7 · Nginx + Certbot ────────────────
nginx_certbot() {
  command -v nginx >/dev/null || install_pkgs nginx
  command -v certbot >/dev/null || install_pkgs certbot python3-certbot-nginx

  read -rp "Dominio (ej. ejemplo.com): " DOM
  read -rp "Raíz proyecto /public [$(pwd)/public]: " ROOT
  ROOT=${ROOT:-$(pwd)/public}
  read -rp "Fichero conf [/etc/nginx/sites-available/${DOM}.conf]: " CONF
  CONF=${CONF:-/etc/nginx/sites-available/${DOM}.conf}

  if [ ! -f "$CONF" ]; then
    sudo tee "$CONF" >/dev/null <<EOF
server {
  listen 80;
  server_name ${DOM} www.${DOM};
  root ${ROOT};
  index index.php index.html;

  add_header X-Frame-Options SAMEORIGIN;
  add_header X-Content-Type-Options nosniff;

  location / {
    try_files \$uri \$uri/ /index.php?\$query_string;
  }

  location ~ \.php\$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/run/php/php8.2-fpm.sock;
  }

  location ~* \.(jpg|jpeg|png|gif|ico|css|js)\$ {
    expires 30d;
    log_not_found off;
  }
}
EOF
  fi

  sudo ln -sf "$CONF" /etc/nginx/sites-enabled/
  sudo nginx -t && sudo systemctl reload nginx

  msg "$GREEN" "→ Solicitando certificado Let’s Encrypt…"
  sudo certbot --nginx -d "$DOM" -d "www.${DOM}" --redirect
}

#──────────────────── Auto-todo ──────────────────────────
auto_all() {
  update_system; [[ -d .git ]] || clone_repo
  pull_changes; composer_install; npm_build; clean_caches
  restart_services
}

#──────────────────── Menú ───────────────────────────────
menu() {
  clear; msg "$GREEN" "╔══ DEPLOY MENU ═════════════════════════════════╗"
  echo "║ 1) Actualizar Sistema   5) npm build + caches     ║"
  echo "║ 2) Clonar repo          6) Reiniciar servicios    ║"
  echo "║ 3) Git pull             7) Nginx + Certbot        ║"
  echo "║ 4) Composer install     0) Auto-todo y salir      ║"
  echo "║ q) Salir                                         ║"
  msg "$GREEN" "╚═══════════════════════════════════════════════╝"
  read -rp "Opción: " op
  case $op in
    1) update_system;;
    2) clone_repo;;
    3) pull_changes;;
    4) composer_install;;
    5) npm_build; clean_caches;;
    6) restart_services;;
    7) nginx_certbot;;
    0) auto_all; exit;;
    q|Q) exit;;
    *) msg "$RED" "Opción inválida";;
  esac
  pause
}

#──────────────────── MAIN ───────────────────────────────
[ "${1:-}" = auto ] && { auto_all; exit; }
while true; do menu; done
