#!/bin/bash
# cola_supervisor.sh - Gestiona colas Laravel con supervisor
# Uso: ./cola_supervisor.sh [start|stop|status|logs]

ACCION=${1:-status}

case $ACCION in
  start)
    supervisorctl start laravel-worker:*
    ;;
  stop)
    supervisorctl stop laravel-worker:*
    ;;
  status)
    supervisorctl status laravel-worker:*
    ;;
  logs)
    tail -f /var/log/supervisor/supervisord.log
    ;;
  *)
    echo "Uso: $0 [start|stop|status|logs]"
    exit 1
    ;;
esac

exit 0 