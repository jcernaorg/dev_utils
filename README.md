# 🚀 Automatización de Servidor para CREAD ONG , EDITABLE!

¡Bienvenido a la suite de scripts de automatización para el servidor de CREAD ONG! Aquí encontrarás herramientas esenciales para mantener, respaldar y asegurar tu infraestructura de producción, tambien editable para otros servidores, o proyectos.

---

## 📋 Índice

- [¿Qué es esto?](#qué-es-esto)
- [Requisitos](#requisitos)
- [Tabla de scripts](#tabla-de-scripts)
- [Instrucciones de uso](#instrucciones-de-uso)
- [Recomendaciones](#recomendaciones)
- [Créditos](#créditos)

---

## 🤔 ¿Qué es esto?

Esta carpeta contiene **scripts bash** para automatizar tareas críticas en servidores Linux con Apache/Nginx, Certbot, Laravel, Node.js y más. ¡Optimiza tu tiempo y reduce errores humanos!

---

## ⚙️ Requisitos

- Linux (Debian/Ubuntu recomendado)
- Acceso root o sudo
- Dependencias: `mysqldump`, `mysql`, `tar`, `scp`/`rclone`, `systemctl`, `certbot`, `mail`, `nvm`, `supervisorctl`
- Laravel `.env` correctamente configurado

---

## 🗂️ Tabla de scripts

| #  | Script                        | ¿Para qué sirve?                                                | Icono |
|----|-------------------------------|-----------------------------------------------------------------|-------|
| 1  | `backup.sh`                   | Copia de seguridad diaria del código + BD + .env                | 🗄️    |
| 2  | `restore.sh`                  | Restaura la copia elegida                                       | ♻️    |
| 3  | `logs.sh`                     | Empaqueta logs (nginx, php, laravel) + limpia > X días          | 📦    |
| 4  | `ssl_renovar.sh`              | Fuerza `certbot renew` + recarga Nginx + e-mail si falla        | 🔒    |
| 5  | `watchdog.sh`                 | Comprueba cada minuto Nginx / PHP-FPM / Node; si caen, reinicia | 🐶    |
| 6  | `actualizar_seguridad.sh`     | Solo `apt-get --just-kernel upgrade` + reboots programados      | 🛡️    |
| 7  | `agregar_usuario_deploy.sh`   | Crea usuario “deploy”, sube su llave SSH, limita permisos       | 👤    |
| 8  | `limpiar_node_modules.sh`     | Borra `node_modules` y `vendor` antiguos en releases pasados    | 🧹    |
| 9  | `cambiar_node.sh`             | Cambia rápidamente entre Node LTS y la versión exigida          | 🔄    |
| 10 | `cola_supervisor.sh`          | Lanza/monitorea colas Laravel con `supervisor`                  | 🕹️    |

---

## 🛠️ Instrucciones de uso

1. **Haz ejecutables los scripts:**
   ```bash
   chmod +x *.sh
   ```
2. **Edita variables si es necesario** (usuario remoto, rutas, emails, etc).
3. **Ejecuta el script deseado:**
   ```bash
   ./backup.sh
   ./restore.sh archivo_backup.tar.gz
   # etc.
   ```
4. **Automatiza con cron:**
   - Ejemplo para backup diario:
     ```bash
     0 2 * * * /var/www/cread_front/scripts/backup.sh
     ```

---

## 💡 Recomendaciones

- **Prueba primero en un entorno de desarrollo.**
- **Lee el código antes de ejecutar.**
- **Asegúrate de tener backups remotos.**
- **Personaliza los scripts según tu infraestructura.**
- **Mantén tu `.env` seguro y actualizado.**

---

## 👨‍💻 Créditos

Desarrollado con ❤️ por [Javier Cerna](https://github.com/Jaacern/)

> _"Automatiza todo lo que puedas, pero nunca dejes de aprender."_

--- 