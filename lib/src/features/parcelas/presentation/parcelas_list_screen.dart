import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/main_navigation.dart';
import '../../../core/theme.dart';
import '../services/parcelas_service.dart';
import '../models/parcela.dart';

/// Provider para obtener las parcelas del usuario
final parcelasListProvider = FutureProvider<List<Parcela>>((ref) async {
  final parcelasService = ref.read(parcelasServiceProvider);
  return await parcelasService.getParcelas();
});

/// Pantalla que muestra la lista de parcelas del usuario
class ParcelasListScreen extends ConsumerWidget {
  final bool showAppBar;

  const ParcelasListScreen({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final body = Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header con búsqueda
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.parcelasAccent.withValues(alpha: 0.4),
                  AppTheme.parcelasAccent.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.parcelasPrimary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: AppTheme.parcelasPrimary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Buscar parcelas...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),

              ],
            ),
          ),
          const SizedBox(height: 32),

          // Lista de parcelas
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final parcelasAsync = ref.watch(parcelasListProvider);

                return parcelasAsync.when(
                  data: (parcelas) {
                    if (parcelas.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return _buildParcelasList(context, parcelas);
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => _buildErrorState(context, error),
                );
              },
            ),
          ),
        ],
      ),
    );

    if (showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mis Parcelas'),
        ),
        body: body,
      );
    }

    return body;
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.parcelasAccent.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.parcelasPrimary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.landscape_outlined,
              size: 64,
              color: AppTheme.parcelasPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No tienes parcelas registradas',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primera parcela para comenzar a gestionar tus cultivos',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/parcelas/nueva'),
            icon: const Icon(Icons.add),
            label: const Text('Crear Primera Parcela'),
          ),
        ],
      ),
    );
  }

  Widget _buildParcelasList(BuildContext context, List<Parcela> parcelas) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: parcelas.length,
      itemBuilder: (context, index) {
        final parcela = parcelas[index];
        return _buildParcelaCard(context, parcela);
      },
    );
  }

  Widget _buildParcelaCard(BuildContext context, Parcela parcela) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.parcelasAccent.withValues(alpha: 0.3),
            AppTheme.parcelasAccent.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.parcelasPrimary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.parcelasPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.landscape_outlined,
            color: AppTheme.parcelasPrimary,
            size: 24,
          ),
        ),
        title: Text(
          parcela.nombre,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkText,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.straighten,
                  size: 16,
                  color: AppTheme.mediumText,
                ),
                const SizedBox(width: 4),
                Text(
                  '${parcela.area} hectáreas',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.eco,
                  size: 16,
                  color: AppTheme.mediumText,
                ),
                const SizedBox(width: 4),
                Text(
                  parcela.tipoCultivo,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mediumText,
                  ),
                ),
              ],
            ),
            if (parcela.fechaSiembra != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppTheme.mediumText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatearFecha(parcela.fechaSiembra!),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mediumText,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.parcelasPrimary,
          size: 16,
        ),
        onTap: () => context.go('/parcelas/editar/${parcela.id}'),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Error al cargar parcelas',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.errorColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Refrescar la lista
              ProviderScope.containerOf(context).refresh(parcelasListProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final meses = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];

    return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
  }
}
