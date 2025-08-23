/// Constantes globales de la aplicación AgriSoft
class AppConstants {
  // =====================================================
  // CONFIGURACIÓN DE SUPABASE
  // =====================================================
  
  /// URL del proyecto Supabase
  /// IMPORTANTE: Reemplaza con tu URL real del proyecto
  /// Ejemplo: https://tu-proyecto-id.supabase.co
  static const String supabaseUrl = 'https://ivpuusfgzehfakmlkgne.supabase.co';
  
  /// Clave anónima de Supabase (clave pública)
  /// IMPORTANTE: Reemplaza con tu clave anónima real
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml2cHV1c2ZnemVoZmFrbWxrZ25lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU5NTU2OTYsImV4cCI6MjA3MTUzMTY5Nn0.X_9mGTCY0XXvlS-cJsKKgllokGleFaijzP-kJ66cOlw';



  // =====================================================
  // CONFIGURACIÓN DE LA APP
  // =====================================================
  
  /// Nombre de la aplicación
  static const String appName = 'AgriSoft';
  
  /// Versión de la aplicación
  static const String appVersion = '1.0.0';
  
  /// Tipos de cultivos predefinidos
  static const List<String> tiposCultivo = [
    'Maíz',
    'Trigo',
    'Arroz',
    'Soja',
    'Frijol',
    'Papa',
    'Tomate',
    'Cebolla',
    'Zanahoria',
    'Lechuga',
    'Otro',
  ];
  
  /// Tipos de labores predefinidos
  static const List<String> tiposLabor = [
    'siembra',
    'fertilizacion',
    'riego',
    'aplicacion',
    'cosecha',
  ];
  
  /// Etiquetas amigables para tipos de labor
  static const Map<String, String> tiposLaborLabels = {
    'siembra': 'Siembra',
    'fertilizacion': 'Fertilización',
    'riego': 'Riego',
    'aplicacion': 'Aplicación',
    'cosecha': 'Cosecha',
  };

  // =====================================================
  // CONFIGURACIÓN DE UI
  // =====================================================
  
  /// Padding estándar de la aplicación
  static const double defaultPadding = 16.0;
  
  /// Radio de bordes estándar
  static const double defaultBorderRadius = 12.0;
  
  /// Espaciado pequeño
  static const double smallSpacing = 8.0;
  
  /// Espaciado mediano
  static const double mediumSpacing = 16.0;
  
  /// Espaciado grande
  static const double largeSpacing = 24.0;

  // =====================================================
  // VALIDACIONES
  // =====================================================
  
  /// Longitud mínima de contraseña
  static const int minPasswordLength = 6;
  
  /// Área mínima de parcela (hectáreas)
  static const double minParcelArea = 0.01;
  
  /// Área máxima de parcela (hectáreas)
  static const double maxParcelArea = 10000.0;
  
  /// Costo máximo por labor
  static const double maxLaborCost = 999999.99;
  
  /// Cantidad máxima por labor
  static const double maxLaborQuantity = 999999.99;

  // =====================================================
  // MENSAJES DE ERROR
  // =====================================================
  
  static const String errorGeneral = 'Ha ocurrido un error inesperado';
  static const String errorInternet = 'Verifica tu conexión a internet';
  static const String errorAuth = 'Error de autenticación';
  static const String errorPermissions = 'Permisos insuficientes';
  static const String errorLocation = 'No se pudo obtener la ubicación';
  
  // =====================================================
  // INSTRUCCIONES DE CONFIGURACIÓN
  // =====================================================
  
  /// Verifica si las constantes están configuradas correctamente
  static bool get isConfigured {
    return supabaseUrl != 'TU_SUPABASE_URL_AQUI' &&
           supabaseAnonKey != 'TU_SUPABASE_ANON_KEY_AQUI';
  }
  
  /// Mensaje de configuración pendiente
  static const String configMessage = '''
CONFIGURACIÓN PENDIENTE:
1. Reemplaza TU_SUPABASE_URL_AQUI con tu URL de Supabase
2. Reemplaza TU_SUPABASE_ANON_KEY_AQUI con tu clave anónima
''';
}
