# 🚀 Script de Despliegue Laravel + Nginx + Certbot

¡Bienvenido al **Script V!** de despliegue automático para proyectos **Laravel** con **Nginx** y **Certbot**! 😎

---

## ✨ Funcionalidad

Este script interactivo automatiza tareas clave para desplegar y mantener proyectos Laravel en servidores Linux:

- 🔄 **Actualización del sistema** (`apt update/upgrade`)
- 🧬 **Clonado y actualización de repositorios Git**
- 🎼 **Instalación de dependencias Composer** (y extensiones PHP necesarias)
- 🛠️ **Instalación y build de dependencias npm** (con chequeo de versión Node)
- 🧹 **Limpieza y cacheo de Laravel**
- ♻️ **Reinicio de servicios** (Nginx, PHP-FPM)
- 🌐 **Configuración de Nginx y Certbot** para HTTPS
- 🧙 **Modo automático**: ejecuta todo el flujo de despliegue de una sola vez
- 🖥️ **Menú interactivo** para ejecutar cada paso manualmente

---

## 🛠️ Cómo usar

1. **Clona este repositorio o copia el script a tu servidor.**
2. Dale permisos de ejecución:
   ```bash
   chmod +x deploy.sh
   ```
3. Ejecútalo:
   ```bash
   ./deploy.sh
   ```
4. Sigue el menú interactivo:
   - `1` Actualizar sistema
   - `2` Clonar repo
   - `3` Git pull
   - `4` Composer install
   - `5` npm build + caches
   - `6` Reiniciar servicios
   - `7` Nginx + Certbot
   - `0` Auto-todo y salir
   - `q` Salir

5. **Modo automático:**
   ```bash
   ./deploy.sh auto
   ```
   Ejecuta todo el flujo sin intervención manual.

---

## ⚠️ Manejo de errores

- El script usa `set -euo pipefail` para abortar ante cualquier error inesperado.
- Mensajes de error claros y coloridos para cada paso fallido.
- Verifica la existencia de comandos y dependencias antes de instalarlas.
- Pausa tras cada acción para revisión manual (en modo menú).
- Si algún paso falla, el script se detiene y muestra el error en rojo 🟥.

---

## 🧩 Cambios futuros

- [ ] Soporte para más versiones de PHP y Node
- [ ] Integración con Docker
- [ ] Backups automáticos antes de deploy
- [ ] Logs detallados de cada ejecución
- [ ] Soporte multi-proyecto y multi-entorno
- [ ] Mejoras en la detección de errores y rollback

---

## 📝 Notas

- Requiere permisos de sudo para instalar paquetes y reiniciar servicios.
- Pensado para Ubuntu/Debian. Puede requerir ajustes en otras distros.
- Personaliza los servicios a reiniciar editando la variable `SERVICIOS` en el script.

---

## 👨‍💻 Autor

- Javier Cerna — [@javier_cerna_](https://twitter.com/javier_cerna_)

---

## 🦾 ¡Despliega como un PRO! 🚀🔥
