import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_breakpoints.dart';


/// Pantalla de herramientas adicionales
class ToolsScreen extends ConsumerWidget {
  final bool showAppBar;

  const ToolsScreen({
    super.key,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: showAppBar ? AppBar(
        title: const Text('Herramientas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ) : null,
      body: ResponsiveBuilder(
        builder: (context, deviceType) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveBreakpoints.getHorizontalPadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!showAppBar) ...[
                  Text(
                    'Herramientas',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: ResponsiveBreakpoints.getSpacing(context, multiplier: 2)),
                ],
                
                // Herramientas principales
                _buildToolsGrid(context, deviceType),
                
                SizedBox(height: ResponsiveBreakpoints.getSpacing(context, multiplier: 3)),
                
                // Herramientas adicionales
                _buildAdditionalTools(context, deviceType),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildToolsGrid(BuildContext context, DeviceType deviceType) {
    final tools = [
      {
        'title': 'Clima',
        'description': 'Pronósticos y alertas meteorológicas',
        'icon': Icons.cloud,
        'color': const Color(0xFF3742FA),
        'locked': true,
      },
      {
        'title': 'Inventario',
        'description': 'Gestión de insumos y productos',
        'icon': Icons.inventory,
        'color': const Color(0xFF5F27CD),
        'locked': true,
      },
      {
        'title': 'Finanzas',
        'description': 'Análisis de rentabilidad',
        'icon': Icons.account_balance_wallet,
        'color': const Color(0xFF2ED573),
        'locked': true,
      },
      {
        'title': 'Calendario',
        'description': 'Planificación agrícola',
        'icon': Icons.calendar_today,
        'color': const Color(0xFF00D2D3),
        'locked': true,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Herramientas Principales',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveBreakpoints.getSpacing(context, multiplier: 2)),
        ResponsiveGrid(
          mobileColumns: 1,
          tabletColumns: 2,
          desktopColumns: 2,
          largeDesktopColumns: 2,
          childAspectRatio: deviceType == DeviceType.mobile ? 2.0 : 3.5,
          children: tools.map((tool) => _buildToolCard(
            context,
            tool['title'] as String,
            tool['description'] as String,
            tool['icon'] as IconData,
            tool['color'] as Color,
            tool['locked'] as bool? ?? false,
            () => _handleToolTap(context, tool['title'] as String, tool['locked'] as bool? ?? false),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildAdditionalTools(BuildContext context, DeviceType deviceType) {
    final additionalTools = [
      {
        'title': 'Reportes',
        'description': 'Generar informes detallados',
        'icon': Icons.assessment,
        'color': const Color(0xFFFF9F43),
      },
      {
        'title': 'Configuración',
        'description': 'Ajustes de la aplicación',
        'icon': Icons.settings,
        'color': const Color(0xFF57606F),
      },
      {
        'title': 'Ayuda',
        'description': 'Soporte y documentación',
        'icon': Icons.help_outline,
        'color': const Color(0xFF8C7AE6),
      },
      {
        'title': 'Notificaciones',
        'description': 'Centro de notificaciones',
        'icon': Icons.notifications,
        'color': const Color(0xFFFF4757),
      },
      {
        'title': 'Backup',
        'description': 'Respaldo de datos',
        'icon': Icons.backup,
        'color': const Color(0xFF00D2D3),
      },
      {
        'title': 'Análisis',
        'description': 'Estadísticas avanzadas',
        'icon': Icons.analytics,
        'color': const Color(0xFF2ED573),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Herramientas Adicionales',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: ResponsiveBreakpoints.getSpacing(context, multiplier: 2)),
        ResponsiveGrid(
          mobileColumns: 1,
          tabletColumns: 3,
          desktopColumns: 3,
          largeDesktopColumns: 3,
          childAspectRatio: deviceType == DeviceType.mobile ? 2.0 : 1.6,
          children: additionalTools.map((tool) => _buildToolCard(
            context,
            tool['title'] as String,
            tool['description'] as String,
            tool['icon'] as IconData,
            tool['color'] as Color,
            true, // Todas las herramientas adicionales están bloqueadas
            () => _showComingSoon(context, tool['title'] as String),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    bool isLocked,
    VoidCallback onTap,
  ) {
    final deviceType = ResponsiveBreakpoints.getDeviceType(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveBreakpoints.getSpacing(context, multiplier: 2)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            deviceType == DeviceType.mobile
                ? Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isLocked
                              ? Colors.grey.withValues(alpha: 0.2)
                              : color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: isLocked ? Colors.grey.shade600 : color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isLocked ? Colors.grey.shade600 : color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isLocked ? 'Próximamente disponible' : description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 4), // Espacio para el candado
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isLocked
                                ? Colors.grey.withValues(alpha: 0.2)
                                : color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            icon,
                            color: isLocked ? Colors.grey.shade600 : color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isLocked ? Colors.grey.shade600 : color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Flexible(
                          child: Text(
                            isLocked ? 'Próximamente' : description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: 11,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
            if (isLocked)
              Positioned(
                top: deviceType == DeviceType.mobile ? 12 : 8,
                right: deviceType == DeviceType.mobile ? 12 : 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.orange.shade700,
                    size: deviceType == DeviceType.mobile ? 18 : 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleToolTap(BuildContext context, String toolName, bool isLocked) {
    if (isLocked) {
      _showComingSoon(context, toolName);
    } else {
      // Para futuras herramientas desbloqueadas
      _showComingSoon(context, toolName);
    }
  }

  void _showComingSoon(BuildContext context, String toolName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.lock_outline,
              color: Colors.orange.shade700,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(toolName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Esta herramienta estará disponible en una próxima actualización.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Mantente atento a las actualizaciones de AgriSoft',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}
