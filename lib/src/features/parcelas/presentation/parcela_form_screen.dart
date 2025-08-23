import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/theme.dart';
import '../services/parcelas_service.dart';
import '../models/parcela.dart';

/// Pantalla para crear o editar una parcela
class ParcelaFormScreen extends ConsumerStatefulWidget {
  final String? parcelaId;

  const ParcelaFormScreen({super.key, this.parcelaId});

  @override
  ConsumerState<ParcelaFormScreen> createState() => _ParcelaFormScreenState();
}

class _ParcelaFormScreenState extends ConsumerState<ParcelaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _areaController = TextEditingController();
  
  String _tipoCultivoSeleccionado = AppConstants.tiposCultivo.first;
  DateTime? _fechaSiembra;
  bool _isLoading = false;

  bool get _isEditing => widget.parcelaId != null;

  @override
  void dispose() {
    _nombreController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _selectFechaSiembra() async {
    try {
      final fecha = await showDatePicker(
        context: context,
        initialDate: _fechaSiembra ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        helpText: 'Seleccionar fecha de siembra',
        cancelText: 'Cancelar',
        confirmText: 'Aceptar',
        fieldLabelText: 'Fecha',
        fieldHintText: 'dd/mm/aaaa',
      );

      if (fecha != null && mounted) {
        setState(() => _fechaSiembra = fecha);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al seleccionar la fecha'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _guardarParcela() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos requeridos'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Validar datos antes de guardar
      final nombre = _nombreController.text.trim();
      final areaText = _areaController.text.trim();

      if (nombre.isEmpty) {
        throw Exception('El nombre de la parcela es requerido');
      }

      final area = double.tryParse(areaText);
      if (area == null || area <= 0) {
        throw Exception('El área debe ser un número válido mayor a 0');
      }

      // Implementar guardado real de parcela
      final parcelasService = ref.read(parcelasServiceProvider);

      if (_isEditing) {
        // Actualizar parcela existente
        final parcelaActualizada = Parcela(
          id: widget.parcelaId!,
          userId: Supabase.instance.client.auth.currentUser!.id,
          nombre: nombre,
          area: area,
          tipoCultivo: _tipoCultivoSeleccionado,
          fechaSiembra: _fechaSiembra,
          createdAt: DateTime.now(), // Se mantendrá el original en la BD
          updatedAt: DateTime.now(),
        );

        await parcelasService.updateParcela(widget.parcelaId!, parcelaActualizada);
      } else {
        // Crear nueva parcela
        final nuevaParcela = Parcela(
          id: '', // Se generará automáticamente en Supabase
          userId: Supabase.instance.client.auth.currentUser!.id,
          nombre: nombre,
          area: area,
          tipoCultivo: _tipoCultivoSeleccionado,
          fechaSiembra: _fechaSiembra,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await parcelasService.insertParcela(nuevaParcela);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(_isEditing ? 'Parcela actualizada exitosamente' : 'Parcela creada exitosamente'),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 3),
          ),
        );

        // Regresar a la pestaña de parcelas
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatearFecha(DateTime fecha) {
    final meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];

    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Parcela'),
        content: const Text('¿Estás seguro de que quieres eliminar esta parcela? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                final parcelasService = ref.read(parcelasServiceProvider);
                await parcelasService.deleteParcela(widget.parcelaId!);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Parcela eliminada exitosamente'),
                        ],
                      ),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                  context.go('/dashboard');
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(child: Text('Error al eliminar: ${e.toString()}')),
                        ],
                      ),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                }
              }
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
      appBar: ParcelaAppBar(
        title: _isEditing ? 'Editar Parcela' : 'Nueva Parcela',
        actions: [
          if (_isEditing)
            AppBarActionButton(
              icon: Icons.delete_outline,
              onPressed: () => _showDeleteDialog(context),
              tooltip: 'Eliminar Parcela',
              color: AppTheme.errorColor,
            ),
          AppBarActionButton(
            icon: Icons.save_outlined,
            onPressed: _isLoading ? () {} : () => _guardarParcela(),
            tooltip: 'Guardar Parcela',
            color: AppTheme.parcelasPrimary,
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
              // Campo nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Parcela',
                  hintText: 'Ej: Parcela Norte, Lote 1',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  if (value.trim().length < 2) {
                    return 'El nombre debe tener al menos 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo área
              TextFormField(
                controller: _areaController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Área (hectáreas)',
                  hintText: 'Ej: 2.5',
                  prefixIcon: Icon(Icons.straighten),
                  suffixText: 'ha',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el área';
                  }
                  final area = double.tryParse(value.trim());
                  if (area == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  if (area < AppConstants.minParcelArea) {
                    return 'El área mínima es ${AppConstants.minParcelArea} ha';
                  }
                  if (area > AppConstants.maxParcelArea) {
                    return 'El área máxima es ${AppConstants.maxParcelArea} ha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dropdown tipo de cultivo
              DropdownButtonFormField<String>(
                value: _tipoCultivoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Cultivo',
                  prefixIcon: Icon(Icons.eco),
                ),
                items: AppConstants.tiposCultivo.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _tipoCultivoSeleccionado = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Selector de fecha de siembra
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.rosyGray.withValues(alpha: 0.3),
                  ),
                ),
                child: InkWell(
                  onTap: _selectFechaSiembra,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: AppTheme.parcelasPrimary,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha de Siembra (Opcional)',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.rosyGray,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _fechaSiembra != null
                                    ? _formatearFecha(_fechaSiembra!)
                                    : 'Seleccionar fecha de siembra',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: _fechaSiembra != null
                                      ? AppTheme.darkText
                                      : AppTheme.lightText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _fechaSiembra != null ? Icons.edit : Icons.arrow_drop_down,
                          color: AppTheme.parcelasPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              if (_fechaSiembra != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _fechaSiembra = null),
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Limpiar fecha'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.rosyGray,
                      side: BorderSide(color: AppTheme.rosyGray.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 32),

              // Botón guardar
              ElevatedButton(
                onPressed: _isLoading ? null : _guardarParcela,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEditing ? 'Actualizar Parcela' : 'Crear Parcela'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
