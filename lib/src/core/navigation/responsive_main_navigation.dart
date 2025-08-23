import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../features/parcelas/presentation/parcelas_list_screen.dart';
import '../../features/labores/presentation/labores_list_screen.dart';
import '../../features/tools/presentation/tools_screen.dart';

import '../responsive/responsive_layout.dart';
import '../responsive/responsive_breakpoints.dart';
import 'navigation_providers.dart';

/// Widget principal de navegación responsivo
class ResponsiveMainNavigation extends ConsumerWidget {
  const ResponsiveMainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveLayout(
      navigationItems: const [
        ResponsiveNavigationItem(
          label: 'Dashboard',
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard,
        ),
        ResponsiveNavigationItem(
          label: 'Parcelas',
          icon: Icons.landscape_outlined,
          activeIcon: Icons.landscape,
        ),
        ResponsiveNavigationItem(
          label: 'Labores',
          icon: Icons.work_outline,
          activeIcon: Icons.work,
        ),
        ResponsiveNavigationItem(
          label: 'Herramientas',
          icon: Icons.apps_outlined,
          activeIcon: Icons.apps,
        ),
      ],
      bodyBuilder: _buildBody,
      floatingActionButton: _buildContextualFAB(context, ref.watch(navigationIndexProvider)),
    );
  }

  /// Construye el cuerpo de la aplicación según la pestaña seleccionada
  Widget _buildBody(BuildContext context, int currentIndex) {
    final screens = [
      const ResponsiveDashboardContent(),
      const ResponsiveParcelasScreen(),
      const ResponsiveLaboresScreen(),
      const ResponsiveToolsScreen(),
    ];

    return ResponsiveContainer(
      child: screens[currentIndex],
    );
  }

  /// Construye el FAB contextual según la pantalla actual
  Widget? _buildContextualFAB(BuildContext context, int currentIndex) {
    // No mostramos FABs en ninguna pantalla para mantener un diseño limpio
    return null;
  }
}

/// Dashboard responsivo
class ResponsiveDashboardContent extends StatelessWidget {
  const ResponsiveDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveBreakpoints.getHorizontalPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estadísticas principales
              _buildStatsSection(context, deviceType),
              SizedBox(height: ResponsiveBreakpoints.getSpacing(context, multiplier: 3)),
              

              
              // Información adicional
              _buildInfoSection(context, deviceType),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(BuildContext context, DeviceType deviceType) {
    final stats = [
      {'title': 'Parcelas', 'value': '3', 'icon': Icons.landscape, 'color': const Color(0xFF2ED573)},
      {'title': 'Labores', 'value': '12', 'icon': Icons.work, 'color': const Color(0xFF3742FA)},
      {'title': 'Inversión', 'value': '\$2,450', 'icon': Icons.trending_up, 'color': const Color(0xFFFFA502)},
      {'title': 'Ganancia', 'value': '\$1,200', 'icon': Icons.account_balance_wallet, 'color': const Color(0xFF5F27CD)},
    ];

    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 4,
      largeDesktopColumns: 4,
      childAspectRatio: deviceType == DeviceType.mobile ? 2.5 : 1.7,
      children: stats.map((stat) => _buildStatCard(
        context,
        stat['title'] as String,
        stat['value'] as String,
        stat['icon'] as IconData,
        stat['color'] as Color,
        deviceType,
      )).toList(),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color, DeviceType deviceType) {
    return Container(
      padding: EdgeInsets.all(ResponsiveBreakpoints.getSpacing(context, multiplier: 2)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: deviceType == DeviceType.mobile
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.trending_up, color: Colors.green.shade600, size: 20),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    Icon(Icons.trending_up, color: Colors.green.shade600, size: 16),
                  ],
                ),
                const Spacer(),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
    );
  }



  Widget _buildInfoSection(BuildContext context, DeviceType deviceType) {
    return Container(
      padding: EdgeInsets.all(ResponsiveBreakpoints.getSpacing(context, multiplier: 3)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Bienvenido a AgriSoft!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveBreakpoints.getSpacing(context)),
          Text(
            'Tu plataforma completa para la gestión agrícola moderna. Optimiza tus cultivos, controla tus finanzas y maximiza tu productividad.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: ResponsiveBreakpoints.getSpacing(context, multiplier: 2)),
          if (deviceType != DeviceType.mobile)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Ver parcelas
                    },
                    icon: const Icon(Icons.landscape_outlined),
                    label: const Text('Ver Parcelas'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Ver labores
                    },
                    icon: const Icon(Icons.work_outline),
                    label: const Text('Ver Labores'),
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Ver parcelas
                    },
                    icon: const Icon(Icons.landscape_outlined),
                    label: const Text('Ver Parcelas'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Ver labores
                    },
                    icon: const Icon(Icons.work_outline),
                    label: const Text('Ver Labores'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }


}

/// Pantalla de parcelas responsiva
class ResponsiveParcelasScreen extends StatelessWidget {
  const ResponsiveParcelasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ParcelasListScreen(showAppBar: false);
  }
}

/// Pantalla de labores responsiva
class ResponsiveLaboresScreen extends StatelessWidget {
  const ResponsiveLaboresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LaboresListScreen(showAppBar: false);
  }
}

/// Pantalla de herramientas responsiva
class ResponsiveToolsScreen extends StatelessWidget {
  const ResponsiveToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ToolsScreen(showAppBar: false);
  }
}
