import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/responsive/responsive_breakpoints.dart';
import '../../analytics/models/analytics_data.dart';

/// Dashboard de inventario con alertas y gestión inteligente
class InventoryDashboard extends ConsumerWidget {
  const InventoryDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        backgroundColor: const Color(0xFF5F27CD).withValues(alpha: 0.1),
        foregroundColor: const Color(0xFF5F27CD),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Agregar nuevo item
            },
            icon: const Icon(Icons.add),
            tooltip: 'Agregar Item',
          ),
          IconButton(
            onPressed: () {
              // TODO: Escanear código de barras
            },
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Escanear Código',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveBreakpoints.getHorizontalPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen del inventario
            _buildInventorySummary(context),
            const SizedBox(height: 24),
            
            // Alertas de inventario
            _buildInventoryAlerts(context),
            const SizedBox(height: 24),
            
            // Categorías de inventario
            _buildInventoryCategories(context),
            const SizedBox(height: 24),
            
            // Items próximos a vencer
            _buildExpiringItems(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Generar reporte de inventario
        },
        backgroundColor: const Color(0xFF5F27CD),
        child: const Icon(Icons.assessment, color: Colors.white),
      ),
    );
  }

  Widget _buildInventorySummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5F27CD), Color(0xFF8C7AE6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen del Inventario',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Total Items',
                  '247',
                  Icons.inventory,
                  Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Valor Total',
                  '\$12,450',
                  Icons.attach_money,
                  Colors.green.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Bajo Stock',
                  '8',
                  Icons.warning,
                  Colors.orange.shade300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Por Vencer',
                  '3',
                  Icons.schedule,
                  Colors.red.shade300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryAlerts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alertas de Inventario',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildAlertCard(
          context,
          'Stock Bajo',
          'Fertilizante NPK 20-20-20',
          'Solo quedan 2 sacos de 50kg',
          Icons.warning,
          Colors.orange,
          'Reabastecer',
        ),
        const SizedBox(height: 12),
        _buildAlertCard(
          context,
          'Próximo a Vencer',
          'Fungicida Cobre',
          'Vence en 15 días',
          Icons.schedule,
          Colors.red,
          'Usar Pronto',
        ),
        const SizedBox(height: 12),
        _buildAlertCard(
          context,
          'Recomendación',
          'Semillas de Maíz',
          'Temporada de siembra próxima',
          Icons.lightbulb,
          Colors.blue,
          'Planificar',
        ),
      ],
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    String type,
    String item,
    String description,
    IconData icon,
    Color color,
    String actionText,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
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
              children: [
                Text(
                  type,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Acción específica
            },
            child: Text(actionText),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryCategories(BuildContext context) {
    final categories = [
      {'name': 'Fertilizantes', 'count': 45, 'icon': Icons.eco, 'color': const Color(0xFF2ED573)},
      {'name': 'Pesticidas', 'count': 23, 'icon': Icons.bug_report, 'color': const Color(0xFFFF4757)},
      {'name': 'Semillas', 'count': 67, 'icon': Icons.grass, 'color': const Color(0xFFFFA502)},
      {'name': 'Herramientas', 'count': 89, 'icon': Icons.build, 'color': const Color(0xFF57606F)},
      {'name': 'Equipos', 'count': 12, 'icon': Icons.precision_manufacturing, 'color': const Color(0xFF3742FA)},
      {'name': 'Combustibles', 'count': 8, 'icon': Icons.local_gas_station, 'color': const Color(0xFF00D2D3)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categorías de Inventario',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveBreakpoints.getGridColumns(
              context,
              mobileColumns: 2,
              tabletColumns: 3,
              desktopColumns: 4,
              largeDesktopColumns: 6,
            ),
            childAspectRatio: ResponsiveBreakpoints.getCardAspectRatio(context),
            crossAxisSpacing: ResponsiveBreakpoints.getSpacing(context),
            mainAxisSpacing: ResponsiveBreakpoints.getSpacing(context),
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(
              context,
              category['name'] as String,
              category['count'] as int,
              category['icon'] as IconData,
              category['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String name,
    int count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExpiringItems(BuildContext context) {
    final expiringItems = [
      InventoryItem(
        id: '1',
        nombre: 'Fungicida Cobre',
        categoria: 'Pesticidas',
        cantidad: 5,
        unidad: 'litros',
        cantidadMinima: 2,
        fechaVencimiento: DateTime.now().add(const Duration(days: 15)),
        costoUnitario: 25.50,
        ubicacion: 'Bodega A',
      ),
      InventoryItem(
        id: '2',
        nombre: 'Insecticida Orgánico',
        categoria: 'Pesticidas',
        cantidad: 3,
        unidad: 'litros',
        cantidadMinima: 1,
        fechaVencimiento: DateTime.now().add(const Duration(days: 22)),
        costoUnitario: 18.75,
        ubicacion: 'Bodega B',
      ),
      InventoryItem(
        id: '3',
        nombre: 'Vitaminas para Plantas',
        categoria: 'Fertilizantes',
        cantidad: 8,
        unidad: 'frascos',
        cantidadMinima: 3,
        fechaVencimiento: DateTime.now().add(const Duration(days: 28)),
        costoUnitario: 12.00,
        ubicacion: 'Bodega A',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Próximos a Vencer',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...expiringItems.map((item) => _buildExpiringItemCard(context, item)),
      ],
    );
  }

  Widget _buildExpiringItemCard(BuildContext context, InventoryItem item) {
    final daysUntilExpiry = item.fechaVencimiento!.difference(DateTime.now()).inDays;
    final isUrgent = daysUntilExpiry <= 7;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUrgent ? Colors.red.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent ? Colors.red.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUrgent ? Colors.red.shade100 : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.schedule,
              color: isUrgent ? Colors.red.shade600 : Colors.orange.shade600,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nombre,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${item.cantidad} ${item.unidad} • ${item.ubicacion}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  'Vence en $daysUntilExpiry días',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isUrgent ? Colors.red.shade600 : Colors.orange.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: Usar producto
                },
                icon: const Icon(Icons.check_circle_outline),
                tooltip: 'Marcar como usado',
              ),
              IconButton(
                onPressed: () {
                  // TODO: Editar item
                },
                icon: const Icon(Icons.edit),
                tooltip: 'Editar',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
