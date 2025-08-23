import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Inicializador de base de datos multiplataforma
class DatabaseInitializer {
  static bool _initialized = false;

  /// Inicializa la base de datos según la plataforma
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Para plataformas desktop (Windows, Linux, macOS)
      if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        // Inicializar sqflite_common_ffi para desktop
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
        
        if (kDebugMode) {
          print('✅ Base de datos inicializada para desktop (${Platform.operatingSystem})');
        }
      } else {
        // Para móviles (Android, iOS) usar sqflite normal
        if (kDebugMode) {
          print('✅ Base de datos inicializada para móvil');
        }
      }
      
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al inicializar base de datos: $e');
      }
      rethrow;
    }
  }

  /// Verifica si la base de datos está inicializada
  static bool get isInitialized => _initialized;

  /// Reinicia el estado de inicialización (útil para testing)
  static void reset() {
    _initialized = false;
  }
}
