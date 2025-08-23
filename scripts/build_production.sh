#!/bin/bash

# =====================================================
# SCRIPT DE BUILD PARA PRODUCCIÓN - AGRISOFT BY EVOLVIX ENTERPRISE
# =====================================================

set -e  # Salir si hay algún error

echo "🚀 Iniciando build de producción para AgriSoft by Evolvix Enterprise..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con color
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que Flutter esté instalado
if ! command -v flutter &> /dev/null; then
    print_error "Flutter no está instalado o no está en el PATH"
    exit 1
fi

print_status "Verificando versión de Flutter..."
flutter --version

# Limpiar builds anteriores
print_status "Limpiando builds anteriores..."
flutter clean

# Obtener dependencias
print_status "Obteniendo dependencias..."
flutter pub get

# Ejecutar análisis de código
print_status "Ejecutando análisis de código..."
if flutter analyze; then
    print_success "Análisis de código completado sin errores"
else
    print_warning "Se encontraron advertencias en el análisis de código"
fi

# Ejecutar tests
print_status "Ejecutando tests..."
if flutter test; then
    print_success "Todos los tests pasaron"
else
    print_warning "Algunos tests fallaron"
fi

# Configurar variables de entorno para producción
export PRODUCTION=true
export DEVELOPMENT=false

# Build para Web (GitHub Pages)
print_status "Construyendo aplicación web para producción..."
flutter build web \
    --release \
    --web-renderer html \
    --base-href /agrisoft/ \
    --dart-define=PRODUCTION=true \
    --dart-define=DEVELOPMENT=false

if [ $? -eq 0 ]; then
    print_success "Build web completado exitosamente"
else
    print_error "Error en el build web"
    exit 1
fi

# Crear archivo .nojekyll para GitHub Pages
print_status "Configurando para GitHub Pages..."
touch build/web/.nojekyll

# Crear archivo CNAME si se especifica dominio personalizado
if [ ! -z "$CUSTOM_DOMAIN" ]; then
    print_status "Configurando dominio personalizado: $CUSTOM_DOMAIN"
    echo "$CUSTOM_DOMAIN" > build/web/CNAME
fi

# Mostrar información del build
print_status "Información del build:"
echo "  📁 Directorio de salida: build/web/"
echo "  🌐 Base href: /agrisoft/"
echo "  🎯 Renderer: HTML"
echo "  🔧 Modo: Producción"

# Verificar tamaño del build
BUILD_SIZE=$(du -sh build/web/ | cut -f1)
print_status "Tamaño del build: $BUILD_SIZE"

# Crear archivo de información del build
cat > build/web/build-info.json << EOF
{
  "buildDate": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "version": "1.0.0",
  "buildNumber": "1",
  "environment": "production",
  "renderer": "html",
  "baseHref": "/agrisoft/",
  "buildSize": "$BUILD_SIZE"
}
EOF

print_success "¡Build de producción completado exitosamente!"
print_status "Para desplegar:"
print_status "  1. Sube el contenido de build/web/ a tu servidor"
print_status "  2. O usa GitHub Actions para despliegue automático"
print_status "  3. Configura las URLs en Supabase Dashboard"

echo ""
print_success "🎉 ¡AgriSoft by Evolvix Enterprise está listo para producción!"
