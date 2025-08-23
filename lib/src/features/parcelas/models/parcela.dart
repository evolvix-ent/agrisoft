import 'package:json_annotation/json_annotation.dart';

part 'parcela.g.dart';

/// Modelo de datos para una parcela agrícola
@JsonSerializable()
class Parcela {
  /// Identificador único de la parcela
  final String id;
  
  /// ID del usuario propietario
  @JsonKey(name: 'user_id')
  final String userId;
  
  /// Nombre descriptivo de la parcela
  final String nombre;
  
  /// Área de la parcela en hectáreas
  final double area;
  
  /// Tipo de cultivo principal
  @JsonKey(name: 'tipo_cultivo')
  final String tipoCultivo;
  
  /// Fecha de siembra (opcional)
  @JsonKey(name: 'fecha_siembra')
  final DateTime? fechaSiembra;
  
  /// Fecha de creación del registro
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  /// Fecha de última actualización
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const Parcela({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.area,
    required this.tipoCultivo,
    this.fechaSiembra,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crea una instancia desde un Map (JSON)
  factory Parcela.fromJson(Map<String, dynamic> json) => _$ParcelaFromJson(json);

  /// Convierte la instancia a un Map (JSON)
  Map<String, dynamic> toJson() => _$ParcelaToJson(this);

  /// Crea una copia con campos modificados
  Parcela copyWith({
    String? id,
    String? userId,
    String? nombre,
    double? area,
    String? tipoCultivo,
    DateTime? fechaSiembra,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Parcela(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nombre: nombre ?? this.nombre,
      area: area ?? this.area,
      tipoCultivo: tipoCultivo ?? this.tipoCultivo,
      fechaSiembra: fechaSiembra ?? this.fechaSiembra,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convierte a Map para inserción en Supabase (sin campos auto-generados)
  Map<String, dynamic> toInsertMap() {
    return {
      'user_id': userId,
      'nombre': nombre,
      'area': area,
      'tipo_cultivo': tipoCultivo,
      if (fechaSiembra != null) 'fecha_siembra': fechaSiembra!.toIso8601String().split('T')[0],
    };
  }

  /// Convierte a Map para actualización en Supabase (sin campos inmutables)
  Map<String, dynamic> toUpdateMap() {
    return {
      'nombre': nombre,
      'area': area,
      'tipo_cultivo': tipoCultivo,
      if (fechaSiembra != null) 'fecha_siembra': fechaSiembra!.toIso8601String().split('T')[0],
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Parcela &&
        other.id == id &&
        other.userId == userId &&
        other.nombre == nombre &&
        other.area == area &&
        other.tipoCultivo == tipoCultivo &&
        other.fechaSiembra == fechaSiembra &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      nombre,
      area,
      tipoCultivo,
      fechaSiembra,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'Parcela(id: $id, nombre: $nombre, area: $area ha, tipoCultivo: $tipoCultivo)';
  }

  /// Getter para mostrar el área formateada
  String get areaFormateada {
    if (area < 1) {
      return '${(area * 10000).toStringAsFixed(0)} m²';
    } else {
      return '${area.toStringAsFixed(2)} ha';
    }
  }

  /// Getter para mostrar la fecha de siembra formateada
  String get fechaSiembraFormateada {
    if (fechaSiembra == null) return 'No definida';
    return '${fechaSiembra!.day.toString().padLeft(2, '0')}/'
           '${fechaSiembra!.month.toString().padLeft(2, '0')}/'
           '${fechaSiembra!.year}';
  }

  /// Calcula los días desde la siembra
  int? get diasDesdeSiembra {
    if (fechaSiembra == null) return null;
    return DateTime.now().difference(fechaSiembra!).inDays;
  }

  /// Determina si la parcela es nueva (creada en los últimos 7 días)
  bool get esNueva {
    return DateTime.now().difference(createdAt).inDays <= 7;
  }
}
