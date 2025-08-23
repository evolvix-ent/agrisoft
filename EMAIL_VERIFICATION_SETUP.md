# 📧 Configuración de Verificación de Email - AgriSoft

Esta guía te ayudará a configurar correctamente la verificación de email en tu aplicación AgriSoft.

## 🎯 Paso 1: Elegir tu Plataforma de Despliegue

Primero, despliega tu aplicación en una de estas plataformas gratuitas:

### Opción A: Netlify (Recomendado)
1. Ve a [netlify.com](https://netlify.com) y crea cuenta
2. Conecta tu repositorio de GitHub
3. Tu URL será: `https://tu-app.netlify.app`

### Opción B: Vercel
1. Ve a [vercel.com](https://vercel.com) y crea cuenta
2. Conecta tu repositorio
3. Tu URL será: `https://tu-app.vercel.app`

### Opción C: Firebase Hosting
1. Instala Firebase CLI: `npm install -g firebase-tools`
2. Ejecuta: `firebase init hosting`
3. Tu URL será: `https://tu-proyecto.web.app`

## 🔧 Paso 2: Actualizar Configuración en el Código

1. **Edita `lib/src/core/config/auth_config.dart`**:
   ```dart
   // Cambia esta línea con tu URL real
   static const String productionBaseUrl = 'https://tu-app-real.netlify.app';
   
   // Cambia a false para producción
   static const bool isDevelopment = false;
   ```

2. **Actualiza las URLs en la lista `allowedRedirectUrls`** con tu dominio real.

## ⚙️ Paso 3: Configurar Supabase Dashboard

### 3.1 Configurar URLs de Autenticación

1. **Ve a tu proyecto en Supabase Dashboard**
2. **Navega a Authentication > URL Configuration**
3. **Configura las siguientes URLs**:

   **Site URL:**
   ```
   https://tu-app-real.netlify.app
   ```

   **Redirect URLs** (agregar una por línea):
   ```
   http://localhost:3000/auth/confirm
   http://localhost:3000/auth/callback
   http://localhost:3000/auth/reset-password
   http://localhost:8080/auth/confirm
   http://localhost:8080/auth/callback
   http://localhost:8080/auth/reset-password
   https://tu-app-real.netlify.app/auth/confirm
   https://tu-app-real.netlify.app/auth/callback
   https://tu-app-real.netlify.app/auth/reset-password
   ```

### 3.2 Configurar Email Templates

1. **Ve a Authentication > Email Templates**
2. **Selecciona "Confirm signup"**
3. **Personaliza el template**:

   **Subject:** `Confirma tu cuenta en AgriSoft`
   
   **Body (HTML):**
   ```html
   <h2>¡Bienvenido a AgriSoft!</h2>
   <p>Gracias por registrarte en AgriSoft, tu aplicación de gestión agrícola.</p>
   <p>Para completar tu registro, confirma tu email haciendo clic en el siguiente enlace:</p>
   <p><a href="{{ .ConfirmationURL }}" style="background-color: #2ED573; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">Confirmar Email</a></p>
   <p>Si no creaste esta cuenta, puedes ignorar este email.</p>
   <p>¡Gracias por elegir AgriSoft!</p>
   ```

### 3.3 Configurar Settings de Email

1. **Ve a Authentication > Settings**
2. **Habilita "Enable email confirmations"**
3. **Configura "Email confirmation redirect URL":**
   ```
   https://tu-app-real.netlify.app/auth/confirm
   ```

## 🧪 Paso 4: Probar la Verificación

### 4.1 Prueba Local
1. **Ejecuta la app localmente:**
   ```bash
   flutter run -d chrome --web-port 8080
   ```

2. **Registra un usuario de prueba**
3. **Revisa tu email** para el enlace de confirmación
4. **Haz clic en el enlace** - debería redirigir a `localhost:8080/auth/confirm`

### 4.2 Prueba en Producción
1. **Despliega tu app** en la plataforma elegida
2. **Registra un usuario** desde la URL de producción
3. **Verifica que el email** contenga enlaces a tu dominio de producción

## 🔍 Solución de Problemas

### Problema: "Invalid redirect URL"
**Solución:** Verifica que todas las URLs estén configuradas correctamente en Supabase Dashboard.

### Problema: Email no llega
**Solución:** 
- Revisa la carpeta de spam
- Verifica que el email esté bien escrito
- Comprueba los logs en Supabase Dashboard > Logs

### Problema: Enlace no funciona
**Solución:**
- Verifica que la URL de confirmación esté configurada correctamente
- Asegúrate de que tu app esté desplegada y accesible

### Problema: Error en auth_callback_screen.dart
**Solución:** Ya corregido en el código. El método `setSession` ahora usa la sintaxis correcta.

## 📝 Checklist Final

- [ ] App desplegada en plataforma elegida
- [ ] URLs actualizadas en `auth_config.dart`
- [ ] Site URL configurada en Supabase
- [ ] Redirect URLs configuradas en Supabase
- [ ] Email templates personalizados
- [ ] Email confirmations habilitadas
- [ ] Prueba local exitosa
- [ ] Prueba en producción exitosa

## 🆘 Soporte

Si tienes problemas:
1. Revisa los logs en Supabase Dashboard
2. Verifica la consola del navegador para errores
3. Asegúrate de que todas las URLs coincidan exactamente
