import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../navigation/main_navigation.dart';
import '../theme.dart';

/// AppBar personalizada con navegación inteligente
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool showBackButton;
  final BackDestination backDestination;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.showBackButton = true,
    this.backDestination = BackDestination.dashboard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(title),
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: showBackButton
          ? IconButton(
              onPressed: onBackPressed ?? () => _handleBackNavigation(context, ref),
              icon: const Icon(Icons.arrow_back),
              tooltip: _getBackTooltip(),
            )
          : null,
      actions: actions,
    );
  }

  void _handleBackNavigation(BuildContext context, WidgetRef ref) {
    switch (backDestination) {
      case BackDestination.dashboard:
        ref.read(navigationIndexProvider.notifier).state = 0;
        context.go('/dashboard');
        break;
      case BackDestination.parcelas:
        ref.read(navigationIndexProvider.notifier).state = 1;
        context.go('/dashboard');
        break;
      case BackDestination.labores:
        ref.read(navigationIndexProvider.notifier).state = 2;
        context.go('/dashboard');
        break;
      case BackDestination.pop:
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/dashboard');
        }
        break;
    }
  }

  String _getBackTooltip() {
    switch (backDestination) {
      case BackDestination.dashboard:
        return 'Volver al Dashboard';
      case BackDestination.parcelas:
        return 'Volver a Parcelas';
      case BackDestination.labores:
        return 'Volver a Labores';
      case BackDestination.pop:
        return 'Atrás';
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Destinos posibles para el botón de retroceso
enum BackDestination {
  dashboard,
  parcelas,
  labores,
  pop,
}

/// AppBar específica para formularios de parcelas
class ParcelaAppBar extends CustomAppBar {
  const ParcelaAppBar({
    super.key,
    required super.title,
    super.actions,
    super.onBackPressed,
  }) : super(
          backgroundColor: AppTheme.parcelasAccent,
          foregroundColor: AppTheme.parcelasPrimary,
          backDestination: BackDestination.parcelas,
        );
}

/// AppBar específica para formularios de labores
class LaborAppBar extends CustomAppBar {
  const LaborAppBar({
    super.key,
    required super.title,
    super.actions,
    super.onBackPressed,
  }) : super(
          backgroundColor: AppTheme.laboresAccent,
          foregroundColor: AppTheme.laboresPrimary,
          backDestination: BackDestination.labores,
        );
}

/// AppBar específica para el dashboard
class DashboardAppBar extends CustomAppBar {
  const DashboardAppBar({
    super.key,
    required super.title,
    super.actions,
    super.onBackPressed,
  }) : super(
          backgroundColor: AppTheme.dashboardAccent,
          foregroundColor: AppTheme.dashboardPrimary,
          backDestination: BackDestination.dashboard,
          showBackButton: false,
        );
}

/// Widget para crear botones de acción contextuales
class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color? color;

  const AppBarActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: (color ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: color ?? Theme.of(context).colorScheme.primary,
        tooltip: tooltip,
      ),
    );
  }
}

/// Botón flotante de navegación rápida
class QuickNavFAB extends ConsumerWidget {
  final List<QuickNavAction> actions;

  const QuickNavFAB({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (actions.isEmpty) return const SizedBox.shrink();

    if (actions.length == 1) {
      final action = actions.first;
      return FloatingActionButton(
        onPressed: action.onPressed,
        tooltip: action.tooltip,
        child: Icon(action.icon),
      );
    }

    return FloatingActionButton(
      onPressed: () => _showQuickActions(context),
      tooltip: 'Acciones rápidas',
      child: const Icon(Icons.add),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Acciones Rápidas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ...actions.map((action) => ListTile(
                  leading: Icon(action.icon, color: action.color),
                  title: Text(action.tooltip),
                  onTap: () {
                    Navigator.pop(context);
                    action.onPressed();
                  },
                )),
          ],
        ),
      ),
    );
  }
}

/// Acción para navegación rápida
class QuickNavAction {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? color;

  const QuickNavAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });
}
