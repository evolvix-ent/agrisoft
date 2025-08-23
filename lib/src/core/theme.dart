import 'package:flutter/material.dart';

/// Tema moderno de la aplicación AgriSoft con Material 3
/// Paleta de colores rica y diferenciada por secciones
class AppTheme {
  // =====================================================
  // PALETA DE COLORES PRINCIPAL (CORAL/ROSADO)
  // =====================================================

  /// Coral vibrante principal - moderno y llamativo
  static const Color primaryCoral = Color(0xFFFF4757);

  /// Coral medio para elementos secundarios
  static const Color mediumCoral = Color(0xFFFF6B7A);

  /// Coral claro para acentos suaves
  static const Color lightCoral = Color(0xFFFF8A95);

  /// Rosa coral muy claro para fondos
  static const Color paleCoral = Color(0xFFFFE5E8);

  /// Coral intenso para elementos destacados
  static const Color deepCoral = Color(0xFFE73C4E);

  /// Gris rosado para texto secundario
  static const Color rosyGray = Color(0xFF57606F);

  /// Blanco rosado para fondos principales
  static const Color rosyWhite = Color(0xFFFFFAFA);

  // =====================================================
  // COLORES ESPECÍFICOS POR SECCIÓN
  // =====================================================

  // DASHBOARD - Tonos vibrantes y modernos
  static const Color dashboardPrimary = Color(0xFFFF9F43);
  static const Color dashboardSecondary = Color(0xFFFFA502);
  static const Color dashboardAccent = Color(0xFFFFF3CD);

  // PARCELAS - Verdes vibrantes y frescos
  static const Color parcelasPrimary = Color(0xFF2ED573);
  static const Color parcelasSecondary = Color(0xFF7BED9F);
  static const Color parcelasAccent = Color(0xFFD1F2EB);

  // LABORES - Azules intensos y profesionales
  static const Color laboresPrimary = Color(0xFF3742FA);
  static const Color laboresSecondary = Color(0xFF5352ED);
  static const Color laboresAccent = Color(0xFFE8E7FF);

  // CLIMA - Azul cielo vibrante
  static const Color climaPrimary = Color(0xFF3742FA);
  static const Color climaSecondary = Color(0xFF70A1FF);
  static const Color climaAccent = Color(0xFFE8EFFF);

  // INVENTARIO - Púrpura moderno
  static const Color inventoryPrimary = Color(0xFF5F27CD);
  static const Color inventorySecondary = Color(0xFF8C7AE6);
  static const Color inventoryAccent = Color(0xFFF1EFFF);

  // FINANZAS - Verde dinero vibrante
  static const Color financePrimary = Color(0xFF2ED573);
  static const Color financeSecondary = Color(0xFF7BED9F);
  static const Color financeAccent = Color(0xFFD1F2EB);

  // CALENDARIO - Teal moderno
  static const Color calendarPrimary = Color(0xFF00D2D3);
  static const Color calendarSecondary = Color(0xFF7FDBDA);
  static const Color calendarAccent = Color(0xFFE0F7F7);

  // TEXTO Y ELEMENTOS NEUTROS
  static const Color darkText = Color(0xFF2D2D2D);
  static const Color mediumText = Color(0xFF5A5A5A);
  static const Color lightText = Color(0xFF8A8A8A);

  // ERRORES Y ESTADOS - Colores más vivos
  static const Color errorColor = Color(0xFFFF4757);
  static const Color successColor = Color(0xFF2ED573);
  static const Color warningColor = Color(0xFFFFA502);
  static const Color infoColor = Color(0xFF3742FA);

  // =====================================================
  // ESQUEMA DE COLORES
  // =====================================================
  
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryCoral,
    onPrimary: Colors.white,
    secondary: mediumCoral,
    onSecondary: Colors.white,
    tertiary: lightCoral,
    onTertiary: deepCoral,
    error: errorColor,
    onError: Colors.white,
    surface: rosyWhite,
    onSurface: deepCoral,
    surfaceContainerHighest: paleCoral,
    outline: rosyGray,
  );

  // =====================================================
  // TEMA PRINCIPAL
  // =====================================================
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      
      // =====================================================
      // TIPOGRAFÍA
      // =====================================================
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: deepCoral,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: deepCoral,
          letterSpacing: -0.25,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: deepCoral,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: primaryCoral,
          letterSpacing: 0.15,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: primaryCoral,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: mediumCoral,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // =====================================================
      // COMPONENTES
      // =====================================================
      
      appBarTheme: const AppBarTheme(
        backgroundColor: rosyWhite,
        foregroundColor: deepCoral,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: deepCoral,
          letterSpacing: 0.15,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCoral,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryCoral,
          side: const BorderSide(color: primaryCoral, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: mediumCoral,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: rosyGray.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: rosyGray.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryCoral, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        filled: true,
        fillColor: paleCoral.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryCoral,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: CircleBorder(),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: rosyWhite,
        selectedItemColor: primaryCoral,
        unselectedItemColor: rosyGray,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: lightCoral.withValues(alpha: 0.3),
        labelStyle: const TextStyle(color: deepCoral),
        side: const BorderSide(color: lightCoral),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      dividerTheme: const DividerThemeData(
        color: rosyGray,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
