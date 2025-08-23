import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../navigation/navigation_providers.dart';
import '../theme.dart';
import 'responsive_breakpoints.dart';
import '../../features/tools/presentation/tools_screen.dart';

/// Layout responsivo principal que adapta la navegación según el dispositivo
class ResponsiveLayout extends ConsumerWidget {
  final List<ResponsiveNavigationItem> navigationItems;
  final Widget Function(BuildContext context, int currentIndex) bodyBuilder;
  final Widget? floatingActionButton;
  final String? title;

  const ResponsiveLayout({
    super.key,
    required this.navigationItems,
    required this.bodyBuilder,
    this.floatingActionButton,
    this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.mobile:
            return _buildMobileLayout(context, ref, currentIndex);
          case DeviceType.tablet:
            return _buildTabletLayout(context, ref, currentIndex);
          case DeviceType.desktop:
          case DeviceType.largeDesktop:
            return _buildDesktopLayout(context, ref, currentIndex);
        }
      },
    );
  }

  /// Layout para móviles - Navegación inferior
  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, int currentIndex) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? navigationItems[currentIndex].label),
        backgroundColor: AppTheme.primaryCoral.withValues(alpha: 0.1),
        foregroundColor: AppTheme.primaryCoral,
        elevation: 0,
        centerTitle: true,
      ),
      body: bodyBuilder(context, currentIndex),
      bottomNavigationBar: _buildFloatingBottomNavigation(context, currentIndex, ref),
      floatingActionButton: floatingActionButton,
    );
  }

  /// Layout para tablets - Navigation Rail
  Widget _buildTabletLayout(BuildContext context, WidgetRef ref, int currentIndex) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) => 
              ref.read(navigationIndexProvider.notifier).state = index,
            labelType: NavigationRailLabelType.selected,
            backgroundColor: Colors.grey.shade50,
            selectedIconTheme: IconThemeData(color: AppTheme.primaryCoral),
            selectedLabelTextStyle: TextStyle(color: AppTheme.primaryCoral),
            unselectedIconTheme: IconThemeData(color: Colors.grey.shade600),
            destinations: navigationItems.map((item) => NavigationRailDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.activeIcon ?? item.icon),
              label: Text(item.label),
            )).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(title ?? navigationItems[currentIndex].label),
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppTheme.darkText,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                ),
                Expanded(
                  child: bodyBuilder(context, currentIndex),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  /// Layout para desktop - Navegación lateral
  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref, int currentIndex) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header del sidebar
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF5F27CD), Color(0xFF8C7AE6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.agriculture,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AgriSoft',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Gestión Agrícola',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Items de navegación
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: navigationItems.length,
                    itemBuilder: (context, index) {
                      final item = navigationItems[index];
                      final isSelected = index == currentIndex;
                      
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        child: ListTile(
                          leading: Icon(
                            isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                            color: isSelected ? AppTheme.primaryCoral : Colors.grey.shade600,
                          ),
                          title: Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected ? AppTheme.primaryCoral : AppTheme.darkText,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: AppTheme.primaryCoral.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onTap: () => ref.read(navigationIndexProvider.notifier).state = index,
                        ),
                      );
                    },
                  ),
                ),
                
                // Footer del sidebar
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.settings, color: Colors.grey.shade600),
                        title: Text(
                          'Configuración',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        onTap: () {
                          // TODO: Abrir configuración
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido principal
          Expanded(
            child: Column(
              children: [
                // Header del contenido
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        title ?? navigationItems[currentIndex].label,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkText,
                        ),
                      ),
                      const Spacer(),
                      // Indicador de conectividad
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.wifi,
                              size: 16,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Conectado',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Contenido
                Expanded(
                  child: bodyBuilder(context, currentIndex),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  /// Construye la navegación inferior flotante para móviles
  Widget _buildFloatingBottomNavigation(BuildContext context, int currentIndex, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppTheme.primaryCoral.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => ref.read(navigationIndexProvider.notifier).state = index,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryCoral,
          unselectedItemColor: Colors.grey.shade600,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.landscape_outlined),
              activeIcon: Icon(Icons.landscape),
              label: 'Parcelas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'Labores',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps_outlined),
              activeIcon: Icon(Icons.apps),
              label: 'Herramientas',
            ),
          ],
        ),
      ),
    );
  }
}

/// Modelo para items de navegación responsiva
class ResponsiveNavigationItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;

  const ResponsiveNavigationItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });
}
