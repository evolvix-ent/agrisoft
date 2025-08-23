/// Modelos para análisis y estadísticas agrícolas

class ProductivityAnalysis {
  final String parcelaId;
  final String parcelaNombre;
  final double areaHectareas;
  final double produccionTotal;
  final double produccionPorHectarea;
  final double costoTotal;
  final double costosPorHectarea;
  final double rentabilidad;
  final DateTime periodo;
  final String cultivo;

  const ProductivityAnalysis({
    required this.parcelaId,
    required this.parcelaNombre,
    required this.areaHectareas,
    required this.produccionTotal,
    required this.produccionPorHectarea,
    required this.costoTotal,
    required this.costosPorHectarea,
    required this.rentabilidad,
    required this.periodo,
    required this.cultivo,
  });

  factory ProductivityAnalysis.fromJson(Map<String, dynamic> json) {
    return ProductivityAnalysis(
      parcelaId: json['parcela_id'] as String,
      parcelaNombre: json['parcela_nombre'] as String,
      areaHectareas: (json['area_hectareas'] as num).toDouble(),
      produccionTotal: (json['produccion_total'] as num).toDouble(),
      produccionPorHectarea: (json['produccion_por_hectarea'] as num).toDouble(),
      costoTotal: (json['costo_total'] as num).toDouble(),
      costosPorHectarea: (json['costos_por_hectarea'] as num).toDouble(),
      rentabilidad: (json['rentabilidad'] as num).toDouble(),
      periodo: DateTime.parse(json['periodo'] as String),
      cultivo: json['cultivo'] as String,
    );
  }
}

class WeatherData {
  final DateTime fecha;
  final double temperatura;
  final double humedad;
  final double precipitacion;
  final double vientoVelocidad;
  final String condicion;
  final String ubicacion;

  const WeatherData({
    required this.fecha,
    required this.temperatura,
    required this.humedad,
    required this.precipitacion,
    required this.vientoVelocidad,
    required this.condicion,
    required this.ubicacion,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      fecha: DateTime.parse(json['fecha'] as String),
      temperatura: (json['temperatura'] as num).toDouble(),
      humedad: (json['humedad'] as num).toDouble(),
      precipitacion: (json['precipitacion'] as num).toDouble(),
      vientoVelocidad: (json['viento_velocidad'] as num).toDouble(),
      condicion: json['condicion'] as String,
      ubicacion: json['ubicacion'] as String,
    );
  }
}

class CropRecommendation {
  final String cultivo;
  final double probabilidadExito;
  final String temporadaOptima;
  final List<String> ventajas;
  final List<String> consideraciones;
  final double inversionEstimada;
  final double retornoEstimado;

  const CropRecommendation({
    required this.cultivo,
    required this.probabilidadExito,
    required this.temporadaOptima,
    required this.ventajas,
    required this.consideraciones,
    required this.inversionEstimada,
    required this.retornoEstimado,
  });

  factory CropRecommendation.fromJson(Map<String, dynamic> json) {
    return CropRecommendation(
      cultivo: json['cultivo'] as String,
      probabilidadExito: (json['probabilidad_exito'] as num).toDouble(),
      temporadaOptima: json['temporada_optima'] as String,
      ventajas: List<String>.from(json['ventajas'] as List),
      consideraciones: List<String>.from(json['consideraciones'] as List),
      inversionEstimada: (json['inversion_estimada'] as num).toDouble(),
      retornoEstimado: (json['retorno_estimado'] as num).toDouble(),
    );
  }
}

class MarketPrice {
  final String producto;
  final double precio;
  final String unidad;
  final DateTime fecha;
  final String mercado;
  final double variacion;
  final String tendencia;

  const MarketPrice({
    required this.producto,
    required this.precio,
    required this.unidad,
    required this.fecha,
    required this.mercado,
    required this.variacion,
    required this.tendencia,
  });

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      producto: json['producto'] as String,
      precio: (json['precio'] as num).toDouble(),
      unidad: json['unidad'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      mercado: json['mercado'] as String,
      variacion: (json['variacion'] as num).toDouble(),
      tendencia: json['tendencia'] as String,
    );
  }
}

class TaskReminder {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fechaVencimiento;
  final String prioridad;
  final String categoria;
  final String parcelaId;
  final bool completada;
  final DateTime? fechaCompletada;

  const TaskReminder({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaVencimiento,
    required this.prioridad,
    required this.categoria,
    required this.parcelaId,
    required this.completada,
    this.fechaCompletada,
  });

  factory TaskReminder.fromJson(Map<String, dynamic> json) {
    return TaskReminder(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      fechaVencimiento: DateTime.parse(json['fecha_vencimiento'] as String),
      prioridad: json['prioridad'] as String,
      categoria: json['categoria'] as String,
      parcelaId: json['parcela_id'] as String,
      completada: json['completada'] as bool,
      fechaCompletada: json['fecha_completada'] != null 
        ? DateTime.parse(json['fecha_completada'] as String)
        : null,
    );
  }
}

class ExpenseCategory {
  final String categoria;
  final double monto;
  final double porcentaje;
  final List<ExpenseItem> items;

  const ExpenseCategory({
    required this.categoria,
    required this.monto,
    required this.porcentaje,
    required this.items,
  });
}

class ExpenseItem {
  final String descripcion;
  final double monto;
  final DateTime fecha;

  const ExpenseItem({
    required this.descripcion,
    required this.monto,
    required this.fecha,
  });
}

class InventoryItem {
  final String id;
  final String nombre;
  final String categoria;
  final double cantidad;
  final String unidad;
  final double cantidadMinima;
  final DateTime? fechaVencimiento;
  final double costoUnitario;
  final String ubicacion;

  const InventoryItem({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.cantidad,
    required this.unidad,
    required this.cantidadMinima,
    this.fechaVencimiento,
    required this.costoUnitario,
    required this.ubicacion,
  });

  bool get necesitaReposicion => cantidad <= cantidadMinima;
  bool get proximoAVencer {
    if (fechaVencimiento == null) return false;
    final diasRestantes = fechaVencimiento!.difference(DateTime.now()).inDays;
    return diasRestantes <= 30;
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      categoria: json['categoria'] as String,
      cantidad: (json['cantidad'] as num).toDouble(),
      unidad: json['unidad'] as String,
      cantidadMinima: (json['cantidad_minima'] as num).toDouble(),
      fechaVencimiento: json['fecha_vencimiento'] != null 
        ? DateTime.parse(json['fecha_vencimiento'] as String)
        : null,
      costoUnitario: (json['costo_unitario'] as num).toDouble(),
      ubicacion: json['ubicacion'] as String,
    );
  }
}

class CropCalendar {
  final String cultivo;
  final List<CropPhase> fases;
  final int duracionTotal;

  const CropCalendar({
    required this.cultivo,
    required this.fases,
    required this.duracionTotal,
  });
}

class CropPhase {
  final String nombre;
  final int diaInicio;
  final int duracion;
  final List<String> actividades;
  final String descripcion;

  const CropPhase({
    required this.nombre,
    required this.diaInicio,
    required this.duracion,
    required this.actividades,
    required this.descripcion,
  });
}
