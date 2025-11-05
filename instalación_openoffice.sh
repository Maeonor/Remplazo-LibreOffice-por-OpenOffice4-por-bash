#!/usr/bin/env bash
# =======================================================
# Autor: Maeonor
# Descripción: Sabe vos para qué, para tarea xd
# =======================================================

set -e

echo "=== Iniciando proceso de instalación de Apache OpenOffice ;D ==="
echo ""

# Paso 1: Ir a la carpeta Descargas
cd ~/Downloads || { echo "No se encontró la carpeta Downloads, ALV"; exit 1; }

# Paso 2: Mostrar archivos disponibles
echo "Archivos encontrados en Downloads: EXITOO :D"
ls -lh
echo ""

# Paso 3: Buscar el archivo .tar.gz de OpenOffice
ARCHIVO=$(ls Apache_OpenOffice_*.tar.gz 2>/dev/null | head -n 1)
# Nota: Cambia el nombre del arhivo como indica la versión, en caso de error
if [[ -z "$ARCHIVO" ]]; then
  echo "No se encontró ningún archivo de Apache_OpenOffice_*.tar.gz en Downloads."
  echo "Por favor, descarga el instalador desde https://www.openoffice.org/download/"
  exit 1
fi

echo "Archivo encontrado: $ARCHIVO"
echo ""

# Paso 4: Extraer el archivo
echo "Extrayendo el contenido..."
tar -xvf "$ARCHIVO"
echo ""

# Paso 5: Entrar en la carpeta de idioma (por ejemplo 'es')
if [[ -d es ]]; then
  cd es
  echo "Entramos a la carpeta: es"
else
  echo "No se encontró la carpeta 'es'. Verifica el archivo descargado."
  exit 1
fi

# Paso 6: Verificar que existe la carpeta DEBS
if [[ -d DEBS ]]; then
  cd DEBS
  echo "Entramos a la carpeta: DEBS"
else
  echo "No se encontró la carpeta 'DEBS'."
  exit 1
fi

# Paso 7: Instalar todos los paquetes .deb
echo "Instalando paquetes .deb..."
sudo dpkg -i *.deb || sudo apt -f install -y
echo "Paquetes base instalados."
echo ""

# Paso 8: Entrar en la carpeta desktop-integration
if [[ -d desktop-integration ]]; then
  cd desktop-integration
  echo "Entramos a la carpeta: desktop-integration"
else
  echo "No se encontró la carpeta 'desktop-integration', pero continuamos."
fi

# Paso 9: Instalar el paquete del menú
DEB_FILE=$(ls openoffice*.deb 2>/dev/null | head -n 1)
if [[ -n "$DEB_FILE" ]]; then
  echo "📦 Instalando integración de escritorio..."
  sudo dpkg -i "$DEB_FILE" || sudo apt -f install -y
  echo "Integración instalada."
else
  echo "No se encontró archivo .deb de integración (desktop-integration)."
fi

# Paso 10: Finalización
echo ""
echo "Instalación completada con éxito"
echo "Puedes iniciar Apache OpenOffice con el comando:"
echo "    openoffice4"
echo ""

# Paso 11: Preguntar si se desea desinstalar
read -rp "¿Deseas desinstalar OpenOffice ahora? (S/n): " RESP
RESP=${RESP:-S}

if [[ "$RESP" =~ ^([sS]|[sS][iI])$ ]]; then
  echo "🧹 Desinstalando OpenOffice..."
  sudo apt remove --purge openoffice* -y
  sudo apt autoremove -y
  sudo apt clean
  echo "OpenOffice eliminado completamente."
else
  echo "OpenOffice se mantiene instalado. ¡Listo!"
fi

echo ""
echo "=== Proceso finalizado ==="
