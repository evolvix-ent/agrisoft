import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/responsive/responsive_breakpoints.dart';
import '../../analytics/models/analytics_data.dart';

/// Calendario agrícola con recordatorios y planificación
class AgriculturalCalendar extends ConsumerStatefulWidget {
  const AgriculturalCalendar({super.key});

  @override
  ConsumerState<AgriculturalCalendar> createState() => _AgriculturalCalendarState();
}

class _AgriculturalCalendarState extends ConsumerState<AgriculturalCalendar> {
  DateTime selectedDate = DateTime.now();
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario Agrícola'),
        backgroundColor: const Color(0xFF00D2D3).withValues(alpha: 0.1),
        foregroundColor: const Color(0xFF00D2D3),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Agregar recordatorio
            },
            icon: const Icon(Icons.add_alert),
            tooltip: 'Nuevo Recordatorio',
          ),
          IconButton(
            onPressed: () {
              // TODO: Vista mensual/semanal
            },
            icon: const Icon(Icons.view_module),
            tooltip: 'Cambiar Vista',
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendario mensual
          _buildMonthlyCalendar(context),
          
          // Actividades del día seleccionado
          Expanded(
            child: _buildDayActivities(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        backgroundColor: const Color(0xFF00D2D3),
        child: const Icon(Icons.add_task, color: Colors.white),
      ),
    );
  }

  Widget _buildMonthlyCalendar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header del mes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
                  });
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                _getMonthYearText(selectedDate),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
                  });
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Días de la semana
          Row(
            children: ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          
          // Grid del calendario
          _buildCalendarGrid(context),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42, // 6 semanas
      itemBuilder: (context, index) {
        final dayNumber = index - firstDayWeekday + 1;
        
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }
        
        final date = DateTime(selectedDate.year, selectedDate.month, dayNumber);
        final isSelected = date.day == selectedDate.day && 
                          date.month == selectedDate.month && 
                          date.year == selectedDate.year;
        final isToday = _isToday(date);
        final hasActivities = _hasActivities(date);
        
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected 
                ? Colors.teal.shade600 
                : isToday 
                  ? Colors.teal.shade100 
                  : null,
              borderRadius: BorderRadius.circular(8),
              border: hasActivities 
                ? Border.all(color: Colors.orange.shade400, width: 2)
                : null,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayNumber.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected 
                        ? Colors.white 
                        : isToday 
                          ? Colors.teal.shade700 
                          : Colors.black87,
                      fontWeight: isSelected || isToday 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                    ),
                  ),
                  if (hasActivities)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.orange.shade600,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayActivities(BuildContext context) {
    final activities = _getActivitiesForDate(selectedDate);
    
    return Container(
      padding: EdgeInsets.all(ResponsiveBreakpoints.getHorizontalPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Actividades para ${_getDateText(selectedDate)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (activities.isNotEmpty)
                Text(
                  '${activities.length} tareas',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (activities.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No hay actividades programadas',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toca el botón + para agregar una nueva tarea',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return _buildActivityCard(context, activities[index]);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, TaskReminder task) {
    Color priorityColor;
    IconData priorityIcon;
    
    switch (task.prioridad) {
      case 'alta':
        priorityColor = Colors.red.shade600;
        priorityIcon = Icons.priority_high;
        break;
      case 'media':
        priorityColor = Colors.orange.shade600;
        priorityIcon = Icons.remove;
        break;
      case 'baja':
        priorityColor = Colors.green.shade600;
        priorityIcon = Icons.low_priority;
        break;
      default:
        priorityColor = Colors.grey.shade600;
        priorityIcon = Icons.remove;
    }

    Color categoryColor;
    IconData categoryIcon;
    
    switch (task.categoria) {
      case 'riego':
        categoryColor = Colors.blue.shade600;
        categoryIcon = Icons.water_drop;
        break;
      case 'fertilizacion':
        categoryColor = Colors.green.shade600;
        categoryIcon = Icons.eco;
        break;
      case 'fumigacion':
        categoryColor = Colors.orange.shade600;
        categoryIcon = Icons.bug_report;
        break;
      case 'cosecha':
        categoryColor = Colors.brown.shade600;
        categoryIcon = Icons.grass;
        break;
      default:
        categoryColor = Colors.grey.shade600;
        categoryIcon = Icons.task;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: task.completada ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.completada ? Colors.grey.shade300 : categoryColor.withValues(alpha: 0.3),
        ),
        boxShadow: task.completada ? null : [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: task.completada,
            onChanged: (value) {
              // TODO: Marcar como completada
            },
            activeColor: categoryColor,
          ),
          const SizedBox(width: 12),
          
          // Icono de categoría
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(categoryIcon, color: categoryColor, size: 20),
          ),
          const SizedBox(width: 16),
          
          // Contenido de la tarea
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.titulo,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: task.completada ? TextDecoration.lineThrough : null,
                          color: task.completada ? Colors.grey.shade600 : null,
                        ),
                      ),
                    ),
                    Icon(priorityIcon, color: priorityColor, size: 16),
                  ],
                ),
                if (task.descripcion.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.descripcion,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: task.completada ? Colors.grey.shade500 : Colors.grey.shade600,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      _getTimeText(task.fechaVencimiento),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Botón de opciones
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  // TODO: Editar tarea
                  break;
                case 'delete':
                  // TODO: Eliminar tarea
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 16),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            child: Icon(Icons.more_vert, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Tarea'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'riego', child: Text('Riego')),
                  DropdownMenuItem(value: 'fertilizacion', child: Text('Fertilización')),
                  DropdownMenuItem(value: 'fumigacion', child: Text('Fumigación')),
                  DropdownMenuItem(value: 'cosecha', child: Text('Cosecha')),
                  DropdownMenuItem(value: 'otro', child: Text('Otro')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Prioridad',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'baja', child: Text('Baja')),
                  DropdownMenuItem(value: 'media', child: Text('Media')),
                  DropdownMenuItem(value: 'alta', child: Text('Alta')),
                ],
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Guardar tarea
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares
  String _getMonthYearText(DateTime date) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getDateText(DateTime date) {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]}';
  }

  String _getTimeText(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _hasActivities(DateTime date) {
    // TODO: Implementar lógica real
    return date.day % 3 == 0; // Simulación
  }

  List<TaskReminder> _getActivitiesForDate(DateTime date) {
    // TODO: Implementar lógica real
    if (!_hasActivities(date)) return [];
    
    return [
      TaskReminder(
        id: '1',
        titulo: 'Riego matutino',
        descripcion: 'Regar parcela norte por 2 horas',
        fechaVencimiento: DateTime(date.year, date.month, date.day, 6, 0),
        prioridad: 'alta',
        categoria: 'riego',
        parcelaId: '1',
        completada: false,
      ),
      TaskReminder(
        id: '2',
        titulo: 'Aplicar fertilizante',
        descripcion: 'NPK 20-20-20 en parcela sur',
        fechaVencimiento: DateTime(date.year, date.month, date.day, 14, 30),
        prioridad: 'media',
        categoria: 'fertilizacion',
        parcelaId: '2',
        completada: date.isBefore(DateTime.now()),
      ),
    ];
  }
}
