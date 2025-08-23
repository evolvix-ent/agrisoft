import 'package:flutter/material.dart';

/// Sistema de breakpoints para diseño responsivo
class ResponsiveBreakpoints {
  // Breakpoints estándar
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;

  // Breakpoints específicos para componentes
  static const double compactWidth = 480;
  static const double mediumWidth = 840;
  static const double expandedWidth = 1240;

  /// Determina si es móvil
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  /// Determina si es tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobile && width < desktop;
  }

  /// Determina si es desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }

  /// Determina si es desktop grande
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktop;
  }

  /// Obtiene el tipo de dispositivo
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < mobile) return DeviceType.mobile;
    if (width < desktop) return DeviceType.tablet;
    if (width < largeDesktop) return DeviceType.desktop;
    return DeviceType.largeDesktop;
  }

  /// Obtiene el número de columnas para grid según el dispositivo
  static int getGridColumns(BuildContext context, {
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
    int largeDesktopColumns = 4,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobileColumns;
      case DeviceType.tablet:
        return tabletColumns;
      case DeviceType.desktop:
        return desktopColumns;
      case DeviceType.largeDesktop:
        return largeDesktopColumns;
    }
  }

  /// Obtiene el padding horizontal según el dispositivo
  static double getHorizontalPadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return 16.0;
      case DeviceType.tablet:
        return 24.0;
      case DeviceType.desktop:
        return 32.0;
      case DeviceType.largeDesktop:
        return 48.0;
    }
  }

  /// Obtiene el ancho máximo del contenido
  static double getMaxContentWidth(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return double.infinity;
      case DeviceType.tablet:
        return 800;
      case DeviceType.desktop:
        return 1200;
      case DeviceType.largeDesktop:
        return 1400;
    }
  }

  /// Obtiene el aspect ratio para tarjetas
  static double getCardAspectRatio(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return 1.2;
      case DeviceType.tablet:
        return 1.3;
      case DeviceType.desktop:
        return 1.4;
      case DeviceType.largeDesktop:
        return 1.5;
    }
  }

  /// Obtiene el tamaño de fuente base
  static double getBaseFontSize(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return 14.0;
      case DeviceType.tablet:
        return 15.0;
      case DeviceType.desktop:
        return 16.0;
      case DeviceType.largeDesktop:
        return 17.0;
    }
  }

  /// Obtiene el espaciado entre elementos
  static double getSpacing(BuildContext context, {double multiplier = 1.0}) {
    final deviceType = getDeviceType(context);
    double baseSpacing;
    
    switch (deviceType) {
      case DeviceType.mobile:
        baseSpacing = 8.0;
        break;
      case DeviceType.tablet:
        baseSpacing = 12.0;
        break;
      case DeviceType.desktop:
        baseSpacing = 16.0;
        break;
      case DeviceType.largeDesktop:
        baseSpacing = 20.0;
        break;
    }
    
    return baseSpacing * multiplier;
  }

  /// Determina si debe usar navegación lateral
  static bool shouldUseSideNavigation(BuildContext context) {
    return isDesktop(context);
  }

  /// Determina si debe usar navegación inferior
  static bool shouldUseBottomNavigation(BuildContext context) {
    return isMobile(context);
  }

  /// Determina si debe usar navegación tipo rail
  static bool shouldUseNavigationRail(BuildContext context) {
    return isTablet(context);
  }
}

/// Enum para tipos de dispositivo
enum DeviceType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}

/// Widget helper para diseño responsivo
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveBreakpoints.getDeviceType(context);
    
    // Si se proporcionan widgets específicos, usarlos
    switch (deviceType) {
      case DeviceType.mobile:
        if (mobile != null) return mobile!;
        break;
      case DeviceType.tablet:
        if (tablet != null) return tablet!;
        break;
      case DeviceType.desktop:
        if (desktop != null) return desktop!;
        break;
      case DeviceType.largeDesktop:
        if (largeDesktop != null) return largeDesktop!;
        break;
    }
    
    // Usar el builder por defecto
    return builder(context, deviceType);
  }
}

/// Widget para contenido con ancho máximo responsivo
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool centerContent;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.centerContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveBreakpoints.getMaxContentWidth(context);
    final horizontalPadding = ResponsiveBreakpoints.getHorizontalPadding(context);
    
    Widget content = Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: padding ?? EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: child,
    );
    
    if (centerContent && ResponsiveBreakpoints.isDesktop(context)) {
      content = Center(child: content);
    }
    
    return content;
  }
}

/// Widget para grid responsivo
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final int? largeDesktopColumns;
  final double? spacing;
  final double? runSpacing;
  final double? childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.largeDesktopColumns,
    this.spacing,
    this.runSpacing,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveBreakpoints.getGridColumns(
      context,
      mobileColumns: mobileColumns ?? 1,
      tabletColumns: tabletColumns ?? 2,
      desktopColumns: desktopColumns ?? 3,
      largeDesktopColumns: largeDesktopColumns ?? 4,
    );
    
    final defaultSpacing = ResponsiveBreakpoints.getSpacing(context);
    final aspectRatio = childAspectRatio ?? ResponsiveBreakpoints.getCardAspectRatio(context);
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: columns,
      crossAxisSpacing: spacing ?? defaultSpacing,
      mainAxisSpacing: runSpacing ?? defaultSpacing,
      childAspectRatio: aspectRatio,
      children: children,
    );
  }
}
