# =====================================================
# DOCKERFILE PARA AGRISOFT - PRODUCCIÓN
# =====================================================

# Etapa 1: Build de la aplicación Flutter
FROM ghcr.io/cirruslabs/flutter:3.24.0 AS build

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración
COPY pubspec.yaml pubspec.lock ./

# Obtener dependencias
RUN flutter pub get

# Copiar código fuente
COPY . .

# Configurar variables de entorno para producción
ENV PRODUCTION=true
ENV DEVELOPMENT=false

# Build de la aplicación web
RUN flutter build web \
    --release \
    --web-renderer html \
    --dart-define=PRODUCTION=true \
    --dart-define=DEVELOPMENT=false

# Etapa 2: Servidor web para servir la aplicación
FROM nginx:alpine AS production

# Copiar configuración personalizada de nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar archivos del build
COPY --from=build /app/build/web /usr/share/nginx/html

# Crear archivo .nojekyll para compatibilidad
RUN touch /usr/share/nginx/html/.nojekyll

# Exponer puerto 80
EXPOSE 80

# Etiquetas de metadatos
LABEL maintainer="Evolvix Enterprise - AgriSoft Team"
LABEL description="AgriSoft by Evolvix Enterprise - Aplicación de gestión agrícola"
LABEL version="1.0.0"
LABEL vendor="Evolvix Enterprise"

# Comando por defecto
CMD ["nginx", "-g", "daemon off;"]
