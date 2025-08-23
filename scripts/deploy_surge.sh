#!/bin/bash

# Script para desplegar en Surge.sh (gratuito)
# Uso: ./scripts/deploy_surge.sh

echo "🚀 Desplegando AgriSoft en Surge.sh..."

# Verificar si surge está instalado
if ! command -v surge &> /dev/null; then
    echo "📦 Instalando Surge.sh..."
    npm install -g surge
fi

# Construir la aplicación
echo "🔨 Construyendo aplicación Flutter..."
flutter build web --release

# Verificar que el build fue exitoso
if [ ! -d "build/web" ]; then
    echo "❌ Error: No se pudo construir la aplicación"
    exit 1
fi

# Crear archivo CNAME para dominio personalizado (opcional)
# echo "tu-dominio.com" > build/web/CNAME

# Desplegar en Surge
echo "🌐 Desplegando en Surge.sh..."
cd build/web

# Si es la primera vez, surge te pedirá email y password
# Después puedes especificar un dominio personalizado
surge . agrisoft-$(date +%s).surge.sh

echo "✅ ¡Despliegue completado!"
echo "🔗 Tu aplicación está disponible en la URL mostrada arriba"
