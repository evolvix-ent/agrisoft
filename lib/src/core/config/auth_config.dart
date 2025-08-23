/// Configuración de autenticación para AgriSoft
class AuthConfig {
  // =====================================================
  // URLs DE REDIRECT PARA AUTENTICACIÓN
  // =====================================================
  
  /// URL base de la aplicación en producción
  /// Configurado para GitHub Pages de Evolvix Enterprise
  static const String productionBaseUrl = 'https://evolvix-ent.github.io/agrisoft';

  /// URL base para desarrollo local
  static const String developmentBaseUrl = 'http://localhost:3000';

  /// Determina si estamos en modo desarrollo
  static const bool isDevelopment = false; // Configurado para producción
  
  /// URL base actual según el entorno
  static String get baseUrl => isDevelopment ? developmentBaseUrl : productionBaseUrl;
  
  /// URL de confirmación de email
  static String get emailConfirmUrl => '$baseUrl/auth/confirm';
  
  /// URL de callback de autenticación
  static String get authCallbackUrl => '$baseUrl/auth/callback';
  
  /// URL de reset de contraseña
  static String get passwordResetUrl => '$baseUrl/auth/reset-password';
  
  // =====================================================
  // CONFIGURACIÓN DE SUPABASE AUTH
  // =====================================================
  
  /// Configuración de URLs para Supabase Dashboard
  /// Estas URLs deben configurarse en:
  /// Supabase Dashboard > Authentication > URL Configuration
  static const List<String> allowedRedirectUrls = [
    // URLs de producción (GitHub Pages - Evolvix Enterprise)
    'https://evolvix-ent.github.io/agrisoft/auth/confirm',
    'https://evolvix-ent.github.io/agrisoft/auth/callback',
    'https://evolvix-ent.github.io/agrisoft/auth/reset-password',

    // URLs de producción (dominio personalizado - Evolvix Enterprise)
    'https://agrisoft.evolvix-ent.com/auth/confirm',
    'https://agrisoft.evolvix-ent.com/auth/callback',
    'https://agrisoft.evolvix-ent.com/auth/reset-password',

    // URLs de desarrollo (mantener para testing)
    'http://localhost:3000/auth/confirm',
    'http://localhost:3000/auth/callback',
    'http://localhost:3000/auth/reset-password',

    // URLs para Flutter Web local
    'http://localhost:8080/auth/confirm',
    'http://localhost:8080/auth/callback',
    'http://localhost:8080/auth/reset-password',
  ];
  
  // =====================================================
  // CONFIGURACIÓN DE EMAILS
  // =====================================================
  
  /// Configuración de templates de email en Supabase
  /// Estos se configuran en: Supabase Dashboard > Authentication > Email Templates
  static const Map<String, String> emailTemplates = {
    'confirm_signup': '''
    <h2>¡Bienvenido a AgriSoft!</h2>
    <p>Gracias por registrarte en AgriSoft, tu aplicación de gestión agrícola.</p>
    <p>Para completar tu registro, confirma tu email haciendo clic en el siguiente enlace:</p>
    <p><a href="{{ .ConfirmationURL }}">Confirmar Email</a></p>
    <p>Si no creaste esta cuenta, puedes ignorar este email.</p>
    <p>¡Gracias por elegir AgriSoft!</p>
    ''',
    
    'recovery': '''
    <h2>Recuperar Contraseña - AgriSoft</h2>
    <p>Recibimos una solicitud para restablecer tu contraseña.</p>
    <p>Haz clic en el siguiente enlace para crear una nueva contraseña:</p>
    <p><a href="{{ .ConfirmationURL }}">Restablecer Contraseña</a></p>
    <p>Si no solicitaste este cambio, puedes ignorar este email.</p>
    <p>El enlace expirará en 1 hora por seguridad.</p>
    ''',
    
    'email_change': '''
    <h2>Confirmar Cambio de Email - AgriSoft</h2>
    <p>Recibimos una solicitud para cambiar tu email.</p>
    <p>Haz clic en el siguiente enlace para confirmar el cambio:</p>
    <p><a href="{{ .ConfirmationURL }}">Confirmar Nuevo Email</a></p>
    <p>Si no solicitaste este cambio, contacta con soporte inmediatamente.</p>
    ''',
  };
  
  // =====================================================
  // INSTRUCCIONES DE CONFIGURACIÓN
  // =====================================================
  
  /// Instrucciones para configurar Supabase Dashboard
  static String get setupInstructions => '''
  CONFIGURACIÓN DE SUPABASE PARA AUTENTICACIÓN:

  1. Ve a tu proyecto en Supabase Dashboard
  2. Navega a Authentication > URL Configuration
  3. Configura las siguientes URLs:

     Site URL: $productionBaseUrl

     Redirect URLs (una por línea):
     ${allowedRedirectUrls.join('\n     ')}

  4. Ve a Authentication > Email Templates
  5. Personaliza los templates con el contenido de emailTemplates

  6. En Authentication > Settings:
     - Habilita "Enable email confirmations"
     - Configura "Email confirmation redirect URL": $productionBaseUrl/auth/confirm

  7. Para producción:
     - Cambia isDevelopment a false
     - Actualiza productionBaseUrl con tu dominio real
     - Actualiza las URLs en el código donde aparece 'tu-dominio.com'
  ''';
  
  /// Verifica si la configuración está lista para producción
  static bool get isProductionReady {
    return !isDevelopment && 
           !productionBaseUrl.contains('tu-dominio.com') &&
           productionBaseUrl.startsWith('https://');
  }
  
  /// Mensaje de advertencia para configuración incompleta
  static String get configWarning {
    if (isDevelopment) {
      return 'Modo desarrollo activo. Recuerda configurar URLs de producción antes del despliegue.';
    } else if (!isProductionReady) {
      return 'ADVERTENCIA: Configuración de producción incompleta. Revisa las URLs.';
    }
    return 'Configuración lista para producción.';
  }
}
