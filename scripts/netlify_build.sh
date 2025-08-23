#!/bin/bash

# Script de build para Netlify - AgriSoft
# Este script instala Flutter y construye la aplicación

set -e  # Salir si hay algún error

echo "🚀 Iniciando build de AgriSoft para Netlify..."

# Definir variables
FLUTTER_VERSION="3.32.5"
FLUTTER_DIR="/opt/buildhome/.flutter"

# Función para instalar Flutter
install_flutter() {
    echo "📦 Instalando Flutter $FLUTTER_VERSION..."
    
    # Crear directorio si no existe
    mkdir -p /opt/buildhome
    
    # Clonar Flutter
    git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_DIR
    
    # Agregar al PATH
    export PATH="$FLUTTER_DIR/bin:$PATH"
    
    echo "✅ Flutter instalado correctamente"
}

# Función para verificar Flutter
verify_flutter() {
    echo "🔍 Verificando instalación de Flutter..."
    
    if ! command -v flutter &> /dev/null; then
        echo "❌ Flutter no encontrado, instalando..."
        install_flutter
    else
        echo "✅ Flutter encontrado"
    fi
    
    # Mostrar versión
    flutter --version
}

# Función para configurar Flutter
setup_flutter() {
    echo "⚙️ Configurando Flutter..."
    
    # Habilitar Flutter Web
    flutter config --enable-web
    
    # Aceptar licencias de Android (por si acaso)
    yes | flutter doctor --android-licenses 2>/dev/null || true
    
    echo "✅ Flutter configurado"
}

# Función para obtener dependencias
get_dependencies() {
    echo "📦 Obteniendo dependencias..."
    
    # Limpiar cache si existe
    flutter clean || true
    
    # Obtener dependencias
    flutter pub get
    
    echo "✅ Dependencias obtenidas"
}

# Función para construir aplicación
build_app() {
    echo "🔨 Construyendo aplicación..."
    
    # Construir para web
    flutter build web --release --web-renderer html
    
    echo "✅ Aplicación construida exitosamente"
}

# Función principal
main() {
    echo "🌟 Build de AgriSoft iniciado"
    echo "=============================="
    
    # Agregar Flutter al PATH si existe
    if [ -d "$FLUTTER_DIR" ]; then
        export PATH="$FLUTTER_DIR/bin:$PATH"
    fi
    
    # Ejecutar pasos
    verify_flutter
    setup_flutter
    get_dependencies
    build_app
    
    echo ""
    echo "🎉 ¡Build completado exitosamente!"
    echo "📁 Archivos generados en: build/web"
}

# Ejecutar función principal
main
