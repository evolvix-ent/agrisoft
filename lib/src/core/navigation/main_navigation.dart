import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/parcelas/presentation/parcelas_list_screen.dart';
import '../../features/labores/presentation/labores_list_screen.dart';
import '../../features/weather/presentation/weather_dashboard.dart';
import '../../features/inventory/presentation/inventory_dashboard.dart';
import '../../features/finance/presentation/finance_dashboard.dart';
import '../../features/calendar/presentation/agricultural_calendar.dart';
import '../theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/connectivity_indicator.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/responsive_breakpoints.dart';

/// Provider para el índice de la navegación actual
final navigationIndexProvider = StateProvider<int>((ref) => 0);

/// Widget principal de navegación con BottomNavigationBar
class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final user = Supabase.instance.client.auth.currentUser;

    // Lista de pantallas principales
    final screens = [
      const DashboardContent(), // Dashboard sin AppBar propia
      const ParcelasListScreen(showAppBar: false),
      const LaboresListScreen(showAppBar: false),
    ];

    // Títulos para cada pestaña
    final titles = [
      'Dashboard',
      'Mis Parcelas',
      'Cuaderno de Labores',
    ];

    // Determinar si mostrar botón de retroceso
    final showBackButton = currentIndex != 0;

    return Scaffold(
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                onPressed: () {
                  // Regresar al Dashboard
                  ref.read(navigationIndexProvider.notifier).state = 0;
                },
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Regresar al Dashboard',
              )
            : null,
        title: Row(
          children: [
            if (!showBackButton) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.eco,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Text(titles[currentIndex]),
          ],
        ),
        actions: [
          // Indicador de conectividad
          const ConnectivityIndicator(showWhenOnline: true),
          const SizedBox(width: 8),
          // Menú de usuario
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) {
                  context.go('/auth/login');
                }
              }
            },
            icon: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person_outline),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Perfil'),
                          Text(
                            user?.email ?? 'Usuario',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_outlined),
                    SizedBox(width: 12),
                    Text('Cerrar Sesión'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Banner offline
          const OfflineBanner(),
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(navigationIndexProvider.notifier).state = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: currentIndex == 0
                    ? BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: const Icon(Icons.dashboard_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.dashboard),
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: currentIndex == 1
                    ? BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: const Icon(Icons.landscape_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.landscape),
              ),
              label: 'Parcelas',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: currentIndex == 2
                    ? BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: const Icon(Icons.assignment_outlined),
              ),
              activeIcon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.assignment),
              ),
              label: 'Labores',
            ),
          ],
        ),
      ),
      floatingActionButton: _buildContextualFAB(context, currentIndex),
    );
  }

  Widget? _buildContextualFAB(BuildContext context, int currentIndex) {
    switch (currentIndex) {
      case 0: // Dashboard
        return QuickNavFAB(
          actions: [
            QuickNavAction(
              icon: Icons.add_location_alt,
              tooltip: 'Nueva Parcela',
              onPressed: () => context.go('/parcelas/nueva'),
              color: AppTheme.parcelasPrimary,
            ),
            QuickNavAction(
              icon: Icons.assignment_add,
              tooltip: 'Nueva Labor',
              onPressed: () => context.go('/labores/nueva'),
              color: AppTheme.laboresPrimary,
            ),
          ],
        );
      case 1: // Parcelas
        return FloatingActionButton(
          onPressed: () => context.go('/parcelas/nueva'),
          backgroundColor: AppTheme.parcelasPrimary,
          tooltip: 'Nueva Parcela',
          child: const Icon(Icons.add, color: Colors.white),
        );
      case 2: // Labores
        return FloatingActionButton(
          onPressed: () => context.go('/labores/nueva'),
          backgroundColor: AppTheme.laboresPrimary,
          tooltip: 'Nueva Labor',
          child: const Icon(Icons.add, color: Colors.white),
        );
      default:
        return null;
    }
  }
}

/// Contenido del dashboard sin AppBar (para usar dentro de MainNavigation)
class DashboardContent extends ConsumerWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo al usuario con animación
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.dashboardAccent.withValues(alpha: 0.4),
                    AppTheme.dashboardAccent.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.dashboardPrimary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.dashboardPrimary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.dashboardPrimary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.wb_sunny_outlined,
                      color: AppTheme.dashboardPrimary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Buen día!',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gestiona tus cultivos de manera inteligente',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Resumen de estadísticas con diseño moderno
          Text(
            'Resumen de Actividad',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
            children: [
              _buildModernStatCard(
                context,
                title: 'Parcelas',
                value: '0',
                icon: Icons.landscape_outlined,
                gradient: [
                  AppTheme.parcelasPrimary,
                  AppTheme.parcelasSecondary,
                ],
                backgroundColor: AppTheme.parcelasAccent,
              ),
              _buildModernStatCard(
                context,
                title: 'Hectáreas',
                value: '0.0',
                icon: Icons.straighten_outlined,
                gradient: [
                  AppTheme.parcelasPrimary,
                  AppTheme.parcelasSecondary,
                ],
                backgroundColor: AppTheme.parcelasAccent,
              ),
              _buildModernStatCard(
                context,
                title: 'Labores',
                value: '0',
                icon: Icons.assignment_outlined,
                gradient: [
                  AppTheme.laboresPrimary,
                  AppTheme.laboresSecondary,
                ],
                backgroundColor: AppTheme.laboresAccent,
              ),
              _buildModernStatCard(
                context,
                title: 'Inversión',
                value: '\$0',
                icon: Icons.trending_up_outlined,
                gradient: [
                  AppTheme.dashboardPrimary,
                  AppTheme.dashboardSecondary,
                ],
                backgroundColor: AppTheme.dashboardAccent,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Funcionalidades adicionales
          _buildAdditionalFeatures(context),
          const SizedBox(height: 32),

          // Información adicional con diseño moderno
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Comienza tu Gestión Agrícola',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Registra tus parcelas, lleva un control detallado de tus labores agrícolas y optimiza tu producción con datos precisos.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Botones de navegación rápida
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final ref = ProviderScope.containerOf(context);
                    ref.read(navigationIndexProvider.notifier).state = 1;
                  },
                  icon: const Icon(Icons.landscape_outlined),
                  label: const Text('Ver Parcelas'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final ref = ProviderScope.containerOf(context);
                    ref.read(navigationIndexProvider.notifier).state = 2;
                  },
                  icon: const Icon(Icons.assignment_outlined),
                  label: const Text('Ver Labores'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildModernStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
    Color? backgroundColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColor?.withValues(alpha: 0.3) ?? gradient[0].withValues(alpha: 0.1),
              backgroundColor?.withValues(alpha: 0.1) ?? gradient[1].withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: gradient[0].withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: gradient[0].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: gradient[0],
                    size: 24,
                  ),
                ),
                Icon(
                  Icons.trending_up,
                  color: gradient[0].withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: gradient[0],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Herramientas Adicionales',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildFeatureCard(
              context,
              'Clima',
              'Pronósticos y alertas meteorológicas',
              Icons.cloud,
              Colors.blue.shade600,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WeatherDashboard()),
              ),
            ),
            _buildFeatureCard(
              context,
              'Inventario',
              'Gestión de insumos y herramientas',
              Icons.inventory,
              Colors.purple.shade600,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InventoryDashboard()),
              ),
            ),
            _buildFeatureCard(
              context,
              'Finanzas',
              'Análisis de rentabilidad',
              Icons.account_balance_wallet,
              Colors.green.shade600,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FinanceDashboard()),
              ),
            ),
            _buildFeatureCard(
              context,
              'Calendario',
              'Planificación agrícola',
              Icons.calendar_today,
              Colors.teal.shade600,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AgriculturalCalendar()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.darkText,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.mediumText,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
