#!/bin/bash

# Script para desplegar en Firebase Hosting
# Uso: ./scripts/deploy_firebase.sh

echo "🔥 Desplegando AgriSoft en Firebase Hosting..."

# Verificar si Firebase CLI está instalado
if ! command -v firebase &> /dev/null; then
    echo "📦 Instalando Firebase CLI..."
    npm install -g firebase-tools
fi

# Verificar si el usuario está logueado
echo "🔐 Verificando autenticación..."
if ! firebase projects:list &> /dev/null; then
    echo "🔑 Iniciando sesión en Firebase..."
    firebase login
fi

# Construir la aplicación
echo "🔨 Construyendo aplicación Flutter..."
flutter clean
flutter pub get
flutter build web --release --web-renderer html

# Verificar que el build fue exitoso
if [ ! -d "build/web" ]; then
    echo "❌ Error: No se pudo construir la aplicación"
    exit 1
fi

# Inicializar Firebase si no existe .firebaserc
if [ ! -f ".firebaserc" ]; then
    echo "⚙️ Configurando Firebase..."
    firebase init hosting
fi

# Desplegar
echo "🚀 Desplegando en Firebase Hosting..."
firebase deploy --only hosting

echo "✅ ¡Despliegue completado!"
echo "🔗 Tu aplicación está disponible en la URL mostrada arriba"
echo "📧 No olvides configurar las URLs en Supabase Dashboard"
