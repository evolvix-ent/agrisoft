import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Pantalla principal del dashboard
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
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
            const Text('AgriSoft'),
          ],
        ),
        actions: [
          // Botón Nueva Parcela
          IconButton(
            onPressed: () => context.go('/parcelas/nueva'),
            icon: const Icon(Icons.add_location_alt_outlined),
            tooltip: 'Nueva Parcela',
          ),
          // Botón Nueva Labor
          IconButton(
            onPressed: () => context.go('/labores/nueva'),
            icon: const Icon(Icons.assignment_add),
            tooltip: 'Nueva Labor',
          ),
          // Botón Ver Parcelas
          IconButton(
            onPressed: () => context.go('/parcelas'),
            icon: const Icon(Icons.landscape_outlined),
            tooltip: 'Mis Parcelas',
          ),
          // Botón Ver Labores
          IconButton(
            onPressed: () => context.go('/labores'),
            icon: const Icon(Icons.assignment_outlined),
            tooltip: 'Cuaderno de Labores',
          ),
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
      body: SingleChildScrollView(
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
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.wb_sunny_outlined,
                        color: Theme.of(context).colorScheme.primary,
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
              childAspectRatio: 1.4,
              children: [
                _buildModernStatCard(
                  context,
                  title: 'Parcelas',
                  value: '0',
                  icon: Icons.landscape_outlined,
                  gradient: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
                _buildModernStatCard(
                  context,
                  title: 'Hectáreas',
                  value: '0.0',
                  icon: Icons.straighten_outlined,
                  gradient: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.secondary.withValues(alpha: 0.7),
                  ],
                ),
                _buildModernStatCard(
                  context,
                  title: 'Labores',
                  value: '0',
                  icon: Icons.assignment_outlined,
                  gradient: [
                    Theme.of(context).colorScheme.tertiary,
                    Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.7),
                  ],
                ),
                _buildModernStatCard(
                  context,
                  title: 'Inversión',
                  value: '\$0',
                  icon: Icons.trending_up_outlined,
                  gradient: [
                    const Color(0xFFB8D4E3),
                    const Color(0xFFB8D4E3).withValues(alpha: 0.7),
                  ],
                ),
              ],
            ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildModernStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradient[0].withValues(alpha: 0.1),
              gradient[1].withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: gradient[0].withValues(alpha: 0.2),
            width: 1,
          ),
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
}
