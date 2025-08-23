import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/connectivity_service.dart';
import '../theme.dart';

/// Widget que muestra el estado de conectividad
class ConnectivityIndicator extends ConsumerWidget {
  final bool showWhenOnline;
  final EdgeInsets? padding;

  const ConnectivityIndicator({
    super.key,
    this.showWhenOnline = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityProvider);
    
    return connectivityAsync.when(
      data: (result) {
        if (result != ConnectivityResult.none && !showWhenOnline) {
          return const SizedBox.shrink();
        }
        
        return _buildIndicator(context, result);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => _buildIndicator(context, ConnectivityResult.none),
    );
  }

  Widget _buildIndicator(BuildContext context, ConnectivityResult result) {
    final isOffline = result == ConnectivityResult.none;
    
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isOffline 
          ? AppTheme.errorColor.withValues(alpha: 0.1)
          : AppTheme.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOffline ? AppTheme.errorColor : AppTheme.successColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOffline ? Icons.cloud_off : Icons.cloud_done,
            size: 16,
            color: isOffline ? AppTheme.errorColor : AppTheme.successColor,
          ),
          const SizedBox(width: 8),
          Text(
            isOffline ? 'Modo offline' : _getConnectionText(result),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isOffline ? AppTheme.errorColor : AppTheme.successColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getConnectionText(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi conectado';
      case ConnectivityResult.mobile:
        return 'Datos móviles';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      default:
        return 'Conectado';
    }
  }
}

/// Banner que se muestra cuando no hay conexión
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    
    if (isOnline) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppTheme.warningColor.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            Icons.cloud_off,
            color: AppTheme.warningColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trabajando sin conexión',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.warningColor,
                  ),
                ),
                Text(
                  'Los cambios se sincronizarán cuando tengas conexión',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.warningColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Botón para forzar sincronización
class SyncButton extends ConsumerWidget {
  final VoidCallback? onPressed;

  const SyncButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    
    return IconButton(
      onPressed: isOnline ? onPressed : null,
      icon: Icon(
        Icons.sync,
        color: isOnline ? AppTheme.primaryCoral : AppTheme.rosyGray,
      ),
      tooltip: isOnline ? 'Sincronizar ahora' : 'Sin conexión',
    );
  }
}

/// Widget que muestra estadísticas de sincronización
class SyncStatusWidget extends ConsumerWidget {
  const SyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implementar cuando tengamos el provider de sync status
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sync,
                size: 20,
                color: AppTheme.primaryCoral,
              ),
              const SizedBox(width: 8),
              Text(
                'Estado de sincronización',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatusRow(
            context,
            'Última sincronización',
            'Hace 5 minutos',
            Icons.schedule,
          ),
          const SizedBox(height: 8),
          _buildStatusRow(
            context,
            'Elementos pendientes',
            '3 parcelas, 1 labor',
            Icons.pending_actions,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.mediumText,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumText,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.darkText,
          ),
        ),
      ],
    );
  }
}

/// Snackbar personalizado para mostrar estado de sincronización
class SyncSnackBar {
  static void showSyncSuccess(BuildContext context, int itemsSynced) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cloud_done, color: Colors.white),
            const SizedBox(width: 8),
            Text('$itemsSynced elementos sincronizados'),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showSyncError(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cloud_off, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('Error de sincronización: $error')),
          ],
        ),
        backgroundColor: AppTheme.errorColor,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Reintentar',
          textColor: Colors.white,
          onPressed: () {
            // TODO: Implementar reintento
          },
        ),
      ),
    );
  }

  static void showOfflineMode(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.cloud_off, color: Colors.white),
            SizedBox(width: 8),
            Text('Trabajando sin conexión'),
          ],
        ),
        backgroundColor: AppTheme.warningColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
