#!/bin/bash
# ===============================================================
# Script de instalación automática de Apache OpenOffice en Ubuntu
# Autor: Maeonor (optimizado y limpio)
# ===============================================================

# === Comprobación de privilegios ===
if [[ $EUID -ne 0 ]]; then
    echo "⚠️  Por favor, ejecuta este script con privilegios de superusuario (sudo).  ⚠️"
    exit 1
fi

# === Actualización del sistema ===
echo "  Actualizando el sistema..."
apt update -y && apt upgrade -y

# === Eliminación de LibreOffice ===
echo "  Eliminando LibreOffice para evitar conflictos..."
apt remove --purge -y libreoffice*
apt autoremove -y
apt clean

# === Variables ===
ARCHIVO=$(ls ~/Downloads/Apache_OpenOffice_*.tar.gz 2>/dev/null | head -n 1)

if [[ -z "$ARCHIVO" ]]; then
    echo "⚠️  No se encontró el archivo de Apache OpenOffice en ~/Downloads.  ⚠️"
    echo "    Descárgalo manualmente desde: https://www.openoffice.org/download/"
    exit 1
fi

# === Extracción ===
echo "  Extrayendo el paquete..."
cd ~/Downloads || exit 1
tar -xvf "$ARCHIVO"

# Detectar carpeta del idioma (puede ser en-US, es, fr, etc.)
CARPETA_IDIOMA=$(find . -type d -name "DEBS" | head -n 1 | sed 's/\/DEBS//')

if [[ -z "$CARPETA_IDIOMA" ]]; then
    echo "❌  No se pudo encontrar el directorio DEBS tras la extracción.  ❌"
    exit 1
fi

# === Instalación de paquetes ===
echo "  Entrando al directorio DEBS e instalando paquetes..."
cd "$CARPETA_IDIOMA/DEBS" || exit 1
dpkg -i *.deb

# === Integración con el escritorio ===
echo "  Instalando integración con el menú de escritorio..."
cd desktop-integration || exit 1
dpkg -i openoffice*.deb

# === Limpieza final ===
echo "  Limpiando archivos temporales..."
apt -f install -y
apt autoremove -y
apt clean

# === Fin ===
echo ""
echo "✅  Instalación completada con éxito.  ✅"
echo "  Puedes iniciar Apache OpenOffice desde el menú o ejecutando:"
echo "    openoffice4"
