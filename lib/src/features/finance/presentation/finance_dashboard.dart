import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/responsive/responsive_breakpoints.dart';

/// Dashboard financiero con análisis de rentabilidad
class FinanceDashboard extends ConsumerWidget {
  const FinanceDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanzas'),
        backgroundColor: const Color(0xFF2ED573).withValues(alpha: 0.1),
        foregroundColor: const Color(0xFF2ED573),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Agregar transacción
            },
            icon: const Icon(Icons.add),
            tooltip: 'Nueva Transacción',
          ),
          IconButton(
            onPressed: () {
              // TODO: Generar reporte
            },
            icon: const Icon(Icons.assessment),
            tooltip: 'Generar Reporte',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveBreakpoints.getHorizontalPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen financiero
            _buildFinancialSummary(context),
            const SizedBox(height: 24),
            
            // Gráfico de ingresos vs gastos
            _buildIncomeExpenseChart(context),
            const SizedBox(height: 24),
            
            // Análisis por parcela
            _buildParcelAnalysis(context),
            const SizedBox(height: 24),
            
            // Transacciones recientes
            _buildRecentTransactions(context),
            const SizedBox(height: 24),
            
            // Proyecciones y metas
            _buildProjections(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransactionDialog(context);
        },
        backgroundColor: const Color(0xFF2ED573),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFinancialSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2ED573), Color(0xFF7BED9F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen Financiero',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Período: Enero - Diciembre 2024',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildFinancialCard(
                  context,
                  'Ingresos',
                  '\$45,230',
                  Icons.trending_up,
                  Colors.green.shade300,
                  '+12.5%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFinancialCard(
                  context,
                  'Gastos',
                  '\$28,450',
                  Icons.trending_down,
                  Colors.red.shade300,
                  '+8.2%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFinancialCard(
                  context,
                  'Ganancia',
                  '\$16,780',
                  Icons.account_balance_wallet,
                  Colors.yellow.shade300,
                  '+18.7%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFinancialCard(
                  context,
                  'ROI',
                  '59.0%',
                  Icons.percent,
                  Colors.blue.shade300,
                  '+5.2%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color iconColor,
    String change,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 24),
              Text(
                change,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseChart(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingresos vs Gastos (Últimos 6 meses)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          // Simulación de gráfico de barras
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildChartBar(context, 'Jul', 0.6, 0.4, Colors.green, Colors.red),
              _buildChartBar(context, 'Ago', 0.7, 0.5, Colors.green, Colors.red),
              _buildChartBar(context, 'Sep', 0.8, 0.6, Colors.green, Colors.red),
              _buildChartBar(context, 'Oct', 0.9, 0.7, Colors.green, Colors.red),
              _buildChartBar(context, 'Nov', 1.0, 0.8, Colors.green, Colors.red),
              _buildChartBar(context, 'Dic', 0.85, 0.65, Colors.green, Colors.red),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(context, 'Ingresos', Colors.green),
              const SizedBox(width: 20),
              _buildLegendItem(context, 'Gastos', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(
    BuildContext context,
    String month,
    double incomeHeight,
    double expenseHeight,
    Color incomeColor,
    Color expenseColor,
  ) {
    const maxHeight = 100.0;
    
    return Column(
      children: [
        SizedBox(
          height: maxHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 20,
                height: incomeHeight * maxHeight,
                decoration: BoxDecoration(
                  color: incomeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 20,
                height: expenseHeight * maxHeight,
                decoration: BoxDecoration(
                  color: expenseColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          month,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildParcelAnalysis(BuildContext context) {
    final parcels = [
      {'name': 'Parcela Norte', 'income': 12500, 'expense': 8200, 'roi': 52.4},
      {'name': 'Parcela Sur', 'income': 18700, 'expense': 11300, 'roi': 65.5},
      {'name': 'Parcela Este', 'income': 14030, 'expense': 8950, 'roi': 56.8},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Análisis por Parcela',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...parcels.map((parcel) => _buildParcelCard(context, parcel)),
      ],
    );
  }

  Widget _buildParcelCard(BuildContext context, Map<String, dynamic> parcel) {
    final profit = parcel['income'] - parcel['expense'];
    final profitColor = profit > 0 ? Colors.green : Colors.red;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                parcel['name'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ROI: ${parcel['roi']}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresos',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '\$${parcel['income']}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gastos',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '\$${parcel['expense']}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ganancia',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '\$${profit}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: profitColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    final transactions = [
      {'type': 'income', 'description': 'Venta de Maíz', 'amount': 2500, 'date': 'Hoy'},
      {'type': 'expense', 'description': 'Fertilizante NPK', 'amount': 450, 'date': 'Ayer'},
      {'type': 'expense', 'description': 'Combustible Tractor', 'amount': 180, 'date': '2 días'},
      {'type': 'income', 'description': 'Venta de Frijol', 'amount': 1200, 'date': '3 días'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transacciones Recientes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Ver todas las transacciones
              },
              child: const Text('Ver Todas'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...transactions.map((transaction) => _buildTransactionItem(context, transaction)),
      ],
    );
  }

  Widget _buildTransactionItem(BuildContext context, Map<String, dynamic> transaction) {
    final isIncome = transaction['type'] == 'income';
    final color = isIncome ? Colors.green : Colors.red;
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  transaction['date'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}\$${transaction['amount']}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjections(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.blue.shade700),
              const SizedBox(width: 12),
              Text(
                'Proyecciones 2025',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProjectionItem(context, 'Ingresos Proyectados', '\$52,000', '+15%'),
          _buildProjectionItem(context, 'Meta de Ahorro', '\$8,000', 'Nuevo'),
          _buildProjectionItem(context, 'ROI Esperado', '62%', '+3%'),
        ],
      ),
    );
  }

  Widget _buildProjectionItem(BuildContext context, String label, String value, String change) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  change,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Transacción'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Monto',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Guardar transacción
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
