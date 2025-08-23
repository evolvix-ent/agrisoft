import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/theme.dart';

/// Pantalla para crear o editar una labor
class LaborFormScreen extends ConsumerStatefulWidget {
  final String? laborId;
  final String? parcelaId;

  const LaborFormScreen({super.key, this.laborId, this.parcelaId});

  @override
  ConsumerState<LaborFormScreen> createState() => _LaborFormScreenState();
}

class _LaborFormScreenState extends ConsumerState<LaborFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _productoController = TextEditingController();
  final _cantidadController = TextEditingController();
  final _costoController = TextEditingController();
  
  String _tipoSeleccionado = AppConstants.tiposLabor.first;
  String? _parcelaSeleccionada;
  DateTime _fecha = DateTime.now();
  bool _isLoading = false;

  bool get _isEditing => widget.laborId != null;

  @override
  void initState() {
    super.initState();
    _parcelaSeleccionada = widget.parcelaId;
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _productoController.dispose();
    _cantidadController.dispose();
    _costoController.dispose();
    super.dispose();
  }

  Future<void> _selectFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale('es', 'ES'),
    );

    if (fecha != null) {
      setState(() => _fecha = fecha);
    }
  }

  Future<void> _guardarLabor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implementar guardado de labor
      await Future.delayed(const Duration(seconds: 1)); // Simulación

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Labor actualizada' : 'Labor registrada'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/labores');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Labor'),
        content: const Text('¿Estás seguro de que quieres eliminar esta labor? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar eliminación real
              context.go('/dashboard');
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LaborAppBar(
        title: _isEditing ? 'Editar Labor' : 'Nueva Labor',
        actions: [
          if (_isEditing)
            AppBarActionButton(
              icon: Icons.delete_outline,
              onPressed: () => _showDeleteDialog(context),
              tooltip: 'Eliminar Labor',
              color: AppTheme.errorColor,
            ),
          AppBarActionButton(
            icon: Icons.save_outlined,
            onPressed: _isLoading ? () {} : () => _guardarLabor(),
            tooltip: 'Guardar Labor',
            color: AppTheme.laboresPrimary,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Selector de parcela (si no viene predefinida)
              if (widget.parcelaId == null) ...[
                DropdownButtonFormField<String>(
                  value: _parcelaSeleccionada,
                  decoration: const InputDecoration(
                    labelText: 'Parcela',
                    prefixIcon: Icon(Icons.landscape),
                  ),
                  hint: const Text('Selecciona una parcela'),
                  items: const [
                    // TODO: Cargar parcelas del usuario
                    DropdownMenuItem(
                      value: null,
                      child: Text('No hay parcelas disponibles'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _parcelaSeleccionada = value);
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor selecciona una parcela';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Dropdown tipo de labor
              DropdownButtonFormField<String>(
                value: _tipoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Labor',
                  prefixIcon: Icon(Icons.work),
                ),
                items: AppConstants.tiposLabor.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(AppConstants.tiposLaborLabels[tipo] ?? tipo),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _tipoSeleccionado = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Selector de fecha
              InkWell(
                onTap: _selectFecha,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de la Labor',
                    prefixIcon: Icon(Icons.calendar_today),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  child: Text(
                    '${_fecha.day.toString().padLeft(2, '0')}/'
                    '${_fecha.month.toString().padLeft(2, '0')}/'
                    '${_fecha.year}',
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo descripción
              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción (Opcional)',
                  hintText: 'Describe los detalles de la labor realizada',
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              const SizedBox(height: 16),

              // Campo producto
              TextFormField(
                controller: _productoController,
                decoration: const InputDecoration(
                  labelText: 'Producto Utilizado (Opcional)',
                  hintText: 'Ej: Fertilizante NPK, Semilla de maíz',
                  prefixIcon: Icon(Icons.inventory),
                ),
              ),
              const SizedBox(height: 16),

              // Campo cantidad
              TextFormField(
                controller: _cantidadController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Cantidad (Opcional)',
                  hintText: 'Ej: 50',
                  prefixIcon: Icon(Icons.straighten),
                  suffixText: 'kg/L/unidades',
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final cantidad = double.tryParse(value.trim());
                    if (cantidad == null) {
                      return 'Por favor ingresa un número válido';
                    }
                    if (cantidad < 0) {
                      return 'La cantidad no puede ser negativa';
                    }
                    if (cantidad > AppConstants.maxLaborQuantity) {
                      return 'La cantidad máxima es ${AppConstants.maxLaborQuantity}';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo costo
              TextFormField(
                controller: _costoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Costo (Opcional)',
                  hintText: 'Ej: 150.00',
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: '\$',
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final costo = double.tryParse(value.trim());
                    if (costo == null) {
                      return 'Por favor ingresa un número válido';
                    }
                    if (costo < 0) {
                      return 'El costo no puede ser negativo';
                    }
                    if (costo > AppConstants.maxLaborCost) {
                      return 'El costo máximo es \$${AppConstants.maxLaborCost}';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Botón guardar
              ElevatedButton(
                onPressed: _isLoading ? null : _guardarLabor,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'Actualizar Labor' : 'Registrar Labor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
