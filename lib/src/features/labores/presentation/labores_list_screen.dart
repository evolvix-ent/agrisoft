import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/main_navigation.dart';
import '../../../core/theme.dart';

/// Pantalla que muestra la lista de labores
class LaboresListScreen extends ConsumerWidget {
  final String? parcelaId;
  final bool showAppBar;

  const LaboresListScreen({super.key, this.parcelaId, this.showAppBar = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isParcelaSpecific = parcelaId != null;

    final body = Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header con filtros
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.laboresAccent.withValues(alpha: 0.4),
                  AppTheme.laboresAccent.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.laboresPrimary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: AppTheme.laboresPrimary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Filtrar labores por tipo, fecha...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),

              ],
            ),
          ),
          const SizedBox(height: 32),

          // Estado vacío
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.laboresAccent.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.laboresPrimary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: AppTheme.laboresPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No hay labores registradas',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isParcelaSpecific
                        ? 'Registra las labores realizadas en esta parcela'
                        : 'Comienza registrando tus actividades agrícolas',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (isParcelaSpecific) {
                        context.go('/labores/nueva?parcela_id=$parcelaId');
                      } else {
                        context.go('/labores/nueva');
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Registrar Primera Labor'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isParcelaSpecific ? 'Labores de la Parcela' : 'Cuaderno de Labores'),
        ),
        body: body,
      );
    }

    return body;
  }
}
