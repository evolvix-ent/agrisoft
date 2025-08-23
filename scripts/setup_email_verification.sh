#!/bin/bash

# Script para configurar verificación de email en AgriSoft
# Uso: ./scripts/setup_email_verification.sh

echo "📧 Configurador de Verificación de Email - AgriSoft"
echo "=================================================="

# Función para mostrar opciones de plataforma
show_platforms() {
    echo ""
    echo "Selecciona tu plataforma de despliegue:"
    echo "1) Netlify (Recomendado)"
    echo "2) Vercel"
    echo "3) Firebase Hosting"
    echo "4) Surge.sh"
    echo "5) GitHub Pages"
    echo "6) Otro (URL personalizada)"
    echo ""
}

# Función para generar URLs
generate_urls() {
    local base_url=$1
    echo ""
    echo "🔗 URLs para configurar en Supabase Dashboard:"
    echo "=============================================="
    echo ""
    echo "Site URL:"
    echo "$base_url"
    echo ""
    echo "Redirect URLs (copiar una por línea):"
    echo "http://localhost:3000/auth/confirm"
    echo "http://localhost:3000/auth/callback"
    echo "http://localhost:3000/auth/reset-password"
    echo "http://localhost:8080/auth/confirm"
    echo "http://localhost:8080/auth/callback"
    echo "http://localhost:8080/auth/reset-password"
    echo "$base_url/auth/confirm"
    echo "$base_url/auth/callback"
    echo "$base_url/auth/reset-password"
    echo ""
}

# Función para actualizar archivo de configuración
update_config() {
    local base_url=$1
    local config_file="lib/src/core/config/auth_config.dart"
    
    if [ -f "$config_file" ]; then
        # Crear backup
        cp "$config_file" "$config_file.backup"
        
        # Actualizar URL de producción
        sed -i "s|static const String productionBaseUrl = '.*';|static const String productionBaseUrl = '$base_url';|" "$config_file"
        
        # Cambiar a modo producción
        sed -i "s|static const bool isDevelopment = true;|static const bool isDevelopment = false;|" "$config_file"
        
        echo "✅ Archivo de configuración actualizado"
        echo "📁 Backup guardado en: $config_file.backup"
    else
        echo "❌ Error: No se encontró el archivo de configuración"
    fi
}

# Mostrar opciones
show_platforms

# Leer selección del usuario
read -p "Ingresa tu opción (1-6): " option

case $option in
    1)
        echo ""
        read -p "Ingresa tu URL de Netlify (ej: https://mi-app.netlify.app): " url
        ;;
    2)
        echo ""
        read -p "Ingresa tu URL de Vercel (ej: https://mi-app.vercel.app): " url
        ;;
    3)
        echo ""
        read -p "Ingresa tu URL de Firebase (ej: https://mi-proyecto.web.app): " url
        ;;
    4)
        echo ""
        read -p "Ingresa tu URL de Surge (ej: https://mi-app.surge.sh): " url
        ;;
    5)
        echo ""
        read -p "Ingresa tu URL de GitHub Pages (ej: https://usuario.github.io/repo): " url
        ;;
    6)
        echo ""
        read -p "Ingresa tu URL personalizada: " url
        ;;
    *)
        echo "❌ Opción inválida"
        exit 1
        ;;
esac

# Validar URL
if [[ ! $url =~ ^https?:// ]]; then
    echo "❌ Error: La URL debe comenzar con http:// o https://"
    exit 1
fi

# Remover trailing slash si existe
url=${url%/}

# Generar URLs
generate_urls "$url"

# Preguntar si actualizar configuración
echo ""
read -p "¿Quieres actualizar automáticamente el archivo de configuración? (y/n): " update

if [[ $update =~ ^[Yy]$ ]]; then
    update_config "$url"
fi

echo ""
echo "🎯 Próximos pasos:"
echo "1. Ve a tu proyecto en Supabase Dashboard"
echo "2. Navega a Authentication > URL Configuration"
echo "3. Copia las URLs mostradas arriba"
echo "4. Ve a Authentication > Email Templates y personaliza los templates"
echo "5. Habilita 'Enable email confirmations' en Authentication > Settings"
echo ""
echo "📖 Para más detalles, consulta: EMAIL_VERIFICATION_SETUP.md"
