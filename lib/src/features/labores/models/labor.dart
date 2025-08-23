import 'package:json_annotation/json_annotation.dart';

part 'labor.g.dart';

/// Modelo de datos para una labor agrícola
@JsonSerializable()
class Labor {
  /// Identificador único de la labor
  final String id;
  
  /// ID de la parcela donde se realizó la labor
  @JsonKey(name: 'parcela_id')
  final String parcelaId;
  
  /// ID del usuario que registró la labor
  @JsonKey(name: 'user_id')
  final String userId;
  
  /// Tipo de labor (siembra, fertilizacion, riego, aplicacion, cosecha)
  final String tipo;
  
  /// Fecha en que se realizó la labor
  final DateTime fecha;
  
  /// Descripción detallada de la labor
  final String? descripcion;
  
  /// Producto utilizado (fertilizante, pesticida, semilla, etc.)
  final String? producto;
  
  /// Cantidad del producto utilizado
  final double? cantidad;
  
  /// Costo de la labor
  final double? costo;
  
  /// Fecha de creación del registro
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  /// Fecha de última actualización
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Labor({
    required this.id,
    required this.parcelaId,
    required this.userId,
    required this.tipo,
    required this.fecha,
    this.descripcion,
    this.producto,
    this.cantidad,
    this.costo,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crea una instancia desde un Map (JSON)
  factory Labor.fromJson(Map<String, dynamic> json) => _$LaborFromJson(json);

  /// Convierte la instancia a un Map (JSON)
  Map<String, dynamic> toJson() => _$LaborToJson(this);

  /// Crea una copia con campos modificados
  Labor copyWith({
    String? id,
    String? parcelaId,
    String? userId,
    String? tipo,
    DateTime? fecha,
    String? descripcion,
    String? producto,
    double? cantidad,
    double? costo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Labor(
      id: id ?? this.id,
      parcelaId: parcelaId ?? this.parcelaId,
      userId: userId ?? this.userId,
      tipo: tipo ?? this.tipo,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      producto: producto ?? this.producto,
      cantidad: cantidad ?? this.cantidad,
      costo: costo ?? this.costo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convierte a Map para inserción en Supabase (sin campos auto-generados)
  Map<String, dynamic> toInsertMap() {
    return {
      'parcela_id': parcelaId,
      'user_id': userId,
      'tipo': tipo,
      'fecha': fecha.toIso8601String().split('T')[0],
      if (descripcion != null && descripcion!.isNotEmpty) 'descripcion': descripcion,
      if (producto != null && producto!.isNotEmpty) 'producto': producto,
      if (cantidad != null) 'cantidad': cantidad,
      if (costo != null) 'costo': costo,
    };
  }

  /// Convierte a Map para actualización en Supabase (sin campos inmutables)
  Map<String, dynamic> toUpdateMap() {
    return {
      'tipo': tipo,
      'fecha': fecha.toIso8601String().split('T')[0],
      if (descripcion != null && descripcion!.isNotEmpty) 'descripcion': descripcion,
      if (producto != null && producto!.isNotEmpty) 'producto': producto,
      if (cantidad != null) 'cantidad': cantidad,
      if (costo != null) 'costo': costo,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Labor &&
        other.id == id &&
        other.parcelaId == parcelaId &&
        other.userId == userId &&
        other.tipo == tipo &&
        other.fecha == fecha &&
        other.descripcion == descripcion &&
        other.producto == producto &&
        other.cantidad == cantidad &&
        other.costo == costo &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      parcelaId,
      userId,
      tipo,
      fecha,
      descripcion,
      producto,
      cantidad,
      costo,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'Labor(id: $id, tipo: $tipo, fecha: $fecha, costo: $costo)';
  }

  /// Getter para mostrar el tipo de labor formateado
  String get tipoFormateado {
    switch (tipo) {
      case 'siembra':
        return 'Siembra';
      case 'fertilizacion':
        return 'Fertilización';
      case 'riego':
        return 'Riego';
      case 'aplicacion':
        return 'Aplicación';
      case 'cosecha':
        return 'Cosecha';
      default:
        return tipo;
    }
  }

  /// Getter para mostrar la fecha formateada
  String get fechaFormateada {
    return '${fecha.day.toString().padLeft(2, '0')}/'
           '${fecha.month.toString().padLeft(2, '0')}/'
           '${fecha.year}';
  }

  /// Getter para mostrar el costo formateado
  String get costoFormateado {
    if (costo == null) return 'No especificado';
    return '\$${costo!.toStringAsFixed(2)}';
  }

  /// Getter para mostrar la cantidad formateada
  String get cantidadFormateada {
    if (cantidad == null) return 'No especificada';
    return cantidad!.toStringAsFixed(2);
  }

  /// Calcula los días desde que se realizó la labor
  int get diasDesdeLabor {
    return DateTime.now().difference(fecha).inDays;
  }

  /// Determina si la labor es reciente (realizada en los últimos 7 días)
  bool get esReciente {
    return diasDesdeLabor <= 7;
  }

  /// Determina si la labor tiene costo asociado
  bool get tieneCosto {
    return costo != null && costo! > 0;
  }

  /// Determina si la labor tiene producto asociado
  bool get tieneProducto {
    return producto != null && producto!.isNotEmpty;
  }

  /// Determina si la labor tiene cantidad especificada
  bool get tieneCantidad {
    return cantidad != null && cantidad! > 0;
  }
}
