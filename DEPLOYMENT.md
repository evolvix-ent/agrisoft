# 🚀 Guía de Despliegue para AgriSoft by Evolvix Enterprise

Esta guía te ayudará a desplegar AgriSoft desarrollado por Evolvix Enterprise en producción usando diferentes métodos.

## 📋 Requisitos Previos

- ✅ Flutter SDK 3.24.0 o superior
- ✅ Proyecto de Supabase configurado
- ✅ Cuenta de GitHub (para GitHub Pages)
- ✅ Dominio personalizado (opcional)

## 🔧 Configuración Inicial

### 1. Configurar Variables de Entorno

Antes del despliegue, actualiza las siguientes configuraciones:

#### En `lib/src/core/config/auth_config.dart`:
```dart
// Configurado para Evolvix Enterprise
static const String productionBaseUrl = 'https://evolvix-ent.github.io/agrisoft';

// O dominio personalizado de Evolvix Enterprise
static const String productionBaseUrl = 'https://agrisoft.evolvix-ent.com';
```

#### En `lib/src/core/constants.dart`:
```dart
// Verificar que tengas tus credenciales reales de Supabase
static const String supabaseUrl = 'https://tu-proyecto.supabase.co';
static const String supabaseAnonKey = 'tu-clave-anonima-real';
```

### 2. Configurar Supabase Dashboard

Ve a tu proyecto en Supabase Dashboard:

1. **Authentication > URL Configuration**:
   ```
   Site URL: https://evolvix-ent.github.io/agrisoft

   Redirect URLs:
   https://evolvix-ent.github.io/agrisoft/auth/confirm
   https://evolvix-ent.github.io/agrisoft/auth/callback
   https://evolvix-ent.github.io/agrisoft/auth/reset-password
   ```

2. **Authentication > Email Templates**:
   - Personaliza los templates con el branding de AgriSoft
   - Asegúrate de que las URLs apunten a tu dominio

## 🌐 Métodos de Despliegue

### Método 1: GitHub Pages (Recomendado)

#### Configuración Automática con GitHub Actions:

1. **Subir código a GitHub**:
   ```bash
   git add .
   git commit -m "Preparar para producción"
   git push origin main
   ```

2. **Habilitar GitHub Pages**:
   - Ve a tu repositorio en GitHub
   - Settings > Pages
   - Source: GitHub Actions
   - El workflow se ejecutará automáticamente

3. **Verificar despliegue**:
   - La aplicación estará disponible en: `https://TU-USUARIO.github.io/agrisoft`

#### Configuración Manual:

1. **Build local**:
   ```bash
   chmod +x scripts/build_production.sh
   ./scripts/build_production.sh
   ```

2. **Subir a GitHub Pages**:
   ```bash
   # Crear rama gh-pages
   git checkout --orphan gh-pages
   git rm -rf .
   cp -r build/web/* .
   git add .
   git commit -m "Deploy to GitHub Pages"
   git push origin gh-pages
   ```

### Método 2: Dominio Personalizado

1. **Configurar DNS**:
   ```
   Tipo: CNAME
   Nombre: agrisoft
   Valor: TU-USUARIO.github.io
   ```

2. **Actualizar configuración**:
   - Cambiar `productionBaseUrl` en `auth_config.dart`
   - Actualizar URLs en Supabase Dashboard

3. **Configurar CNAME**:
   ```bash
   echo "agrisoft.tu-dominio.com" > build/web/CNAME
   ```

### Método 3: Docker + Servidor VPS

1. **Build de imagen Docker**:
   ```bash
   docker build -t agrisoft:latest .
   ```

2. **Ejecutar contenedor**:
   ```bash
   docker run -d -p 80:80 --name agrisoft agrisoft:latest
   ```

3. **Con Docker Compose**:
   ```yaml
   version: '3.8'
   services:
     agrisoft:
       build: .
       ports:
         - "80:80"
       restart: unless-stopped
   ```

### Método 4: Netlify

1. **Conectar repositorio**:
   - Ve a Netlify Dashboard
   - New site from Git
   - Conecta tu repositorio

2. **Configurar build**:
   ```
   Build command: flutter build web --release --web-renderer html
   Publish directory: build/web
   ```

3. **Variables de entorno**:
   ```
   PRODUCTION=true
   DEVELOPMENT=false
   ```

## 🔍 Verificación Post-Despliegue

### Checklist de Verificación:

- [ ] ✅ La aplicación carga correctamente
- [ ] ✅ El registro de usuarios funciona
- [ ] ✅ Los emails de confirmación llegan
- [ ] ✅ Los enlaces de confirmación funcionan
- [ ] ✅ El login funciona correctamente
- [ ] ✅ Las funcionalidades principales están disponibles
- [ ] ✅ La aplicación es responsiva en móvil
- [ ] ✅ No hay errores en la consola del navegador

### Herramientas de Monitoreo:

1. **Google Analytics** (opcional):
   ```html
   <!-- Agregar a web/index.html -->
   <script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
   ```

2. **Sentry** para error tracking (opcional):
   ```dart
   // Agregar a main.dart
   await SentryFlutter.init((options) {
     options.dsn = 'YOUR_SENTRY_DSN';
   });
   ```

## 🛠️ Mantenimiento

### Actualizaciones:

1. **Actualizar código**:
   ```bash
   git pull origin main
   ./scripts/build_production.sh
   ```

2. **Despliegue automático**:
   - Los cambios en `main` se despliegan automáticamente con GitHub Actions

### Backup:

1. **Base de datos Supabase**:
   - Configurar backups automáticos en Supabase Dashboard
   - Exportar datos regularmente

2. **Código fuente**:
   - Mantener repositorio actualizado
   - Tags para versiones estables

## 🚨 Solución de Problemas

### Problemas Comunes:

1. **Error 404 en rutas**:
   - Verificar configuración de SPA en servidor
   - Asegurar que `index.html` maneja todas las rutas

2. **Emails no llegan**:
   - Verificar configuración de URLs en Supabase
   - Revisar spam/promociones

3. **Error de CORS**:
   - Configurar dominios permitidos en Supabase
   - Verificar headers de seguridad

4. **Aplicación no carga**:
   - Verificar consola del navegador
   - Comprobar que todos los assets se cargan correctamente

### Logs y Debugging:

1. **Logs de Supabase**:
   - Dashboard > Logs
   - Filtrar por errores de autenticación

2. **Logs del servidor**:
   ```bash
   # Para Docker
   docker logs agrisoft
   
   # Para nginx
   tail -f /var/log/nginx/error.log
   ```

## 📞 Soporte

Si encuentras problemas durante el despliegue:

1. Revisa esta documentación
2. Verifica la configuración de Supabase
3. Consulta los logs de error
4. Verifica que todas las URLs estén correctamente configuradas

---

**¡AgriSoft está listo para producción! 🌱**
