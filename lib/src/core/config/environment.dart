/// Configuración de entorno para AgriSoft
class Environment {
  // =====================================================
  // CONFIGURACIÓN DE ENTORNO
  // =====================================================
  
  /// Determina si estamos en modo desarrollo
  static const bool isDevelopment = bool.fromEnvironment('DEVELOPMENT', defaultValue: false);
  
  /// Determina si estamos en modo producción
  static const bool isProduction = bool.fromEnvironment('PRODUCTION', defaultValue: true);
  
  /// Determina si estamos en modo testing
  static const bool isTesting = bool.fromEnvironment('TESTING', defaultValue: false);
  
  // =====================================================
  // CONFIGURACIÓN DE SUPABASE
  // =====================================================
  
  /// URL de Supabase (debe configurarse en variables de entorno)
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://tu-proyecto.supabase.co',
  );
  
  /// Clave anónima de Supabase (debe configurarse en variables de entorno)
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'tu-clave-anonima-aqui',
  );
  
  // =====================================================
  // CONFIGURACIÓN DE LA APLICACIÓN
  // =====================================================
  
  /// Nombre de la aplicación
  static const String appName = 'AgriSoft';
  
  /// Versión de la aplicación
  static const String appVersion = '1.0.0';
  
  /// Build number
  static const String buildNumber = '1';
  
  /// URL base de la aplicación
  static String get baseUrl {
    if (isDevelopment) {
      return 'http://localhost:3000';
    } else {
      return 'https://evolvix-ent.github.io/agrisoft';
    }
  }
  
  // =====================================================
  // CONFIGURACIÓN DE BASE DE DATOS
  // =====================================================
  
  /// Nombre de la base de datos local
  static const String databaseName = 'agrisoft.db';
  
  /// Versión de la base de datos
  static const int databaseVersion = 1;
  
  // =====================================================
  // CONFIGURACIÓN DE LOGGING
  // =====================================================
  
  /// Nivel de logging
  static String get logLevel {
    if (isDevelopment) {
      return 'DEBUG';
    } else if (isTesting) {
      return 'INFO';
    } else {
      return 'ERROR';
    }
  }
  
  /// Habilitar logging en consola
  static bool get enableConsoleLogging => isDevelopment || isTesting;
  
  /// Habilitar logging en archivo
  static bool get enableFileLogging => isProduction;
  
  // =====================================================
  // CONFIGURACIÓN DE CARACTERÍSTICAS
  // =====================================================
  
  /// Habilitar modo debug
  static bool get enableDebugMode => isDevelopment;
  
  /// Habilitar analytics
  static bool get enableAnalytics => isProduction;
  
  /// Habilitar crash reporting
  static bool get enableCrashReporting => isProduction;
  
  /// Habilitar actualizaciones automáticas
  static bool get enableAutoUpdates => isProduction;
  
  // =====================================================
  // CONFIGURACIÓN DE TIMEOUTS
  // =====================================================
  
  /// Timeout para requests HTTP (en segundos)
  static const int httpTimeout = 30;
  
  /// Timeout para conexión a base de datos (en segundos)
  static const int databaseTimeout = 10;
  
  /// Timeout para autenticación (en segundos)
  static const int authTimeout = 60;
  
  // =====================================================
  // CONFIGURACIÓN DE CACHE
  // =====================================================
  
  /// Tamaño máximo de cache en MB
  static const int maxCacheSize = 100;
  
  /// Tiempo de vida del cache en horas
  static const int cacheLifetime = 24;
  
  // =====================================================
  // MÉTODOS DE UTILIDAD
  // =====================================================
  
  /// Verifica si la configuración es válida
  static bool get isConfigValid {
    return supabaseUrl.isNotEmpty && 
           supabaseAnonKey.isNotEmpty &&
           !supabaseUrl.contains('tu-proyecto') &&
           !supabaseAnonKey.contains('tu-clave');
  }
  
  /// Obtiene información del entorno actual
  static Map<String, dynamic> get environmentInfo => {
    'isDevelopment': isDevelopment,
    'isProduction': isProduction,
    'isTesting': isTesting,
    'appName': appName,
    'appVersion': appVersion,
    'buildNumber': buildNumber,
    'baseUrl': baseUrl,
    'logLevel': logLevel,
    'isConfigValid': isConfigValid,
  };
  
  /// Mensaje de estado de configuración
  static String get configStatus {
    if (!isConfigValid) {
      return 'ADVERTENCIA: Configuración incompleta. Revisa las variables de entorno.';
    } else if (isDevelopment) {
      return 'Modo desarrollo activo.';
    } else {
      return 'Configuración de producción lista.';
    }
  }
}
