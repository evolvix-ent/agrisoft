# Dockerfile para build de Flutter en Netlify
FROM ubuntu:20.04

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Instalar Flutter
ENV FLUTTER_VERSION=3.32.5
ENV FLUTTER_HOME=/flutter
ENV PATH=$FLUTTER_HOME/bin:$PATH

RUN curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
    | tar -xJ -C / \
    && flutter config --enable-web \
    && flutter doctor

# Configurar directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY . .

# Obtener dependencias y construir
RUN flutter pub get && flutter build web --release

# Los archivos construidos estarán en /app/build/web
