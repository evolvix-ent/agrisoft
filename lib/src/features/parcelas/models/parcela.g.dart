// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcela.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Parcela _$ParcelaFromJson(Map<String, dynamic> json) => Parcela(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      nombre: json['nombre'] as String,
      area: (json['area'] as num).toDouble(),
      tipoCultivo: json['tipo_cultivo'] as String,
      fechaSiembra: json['fecha_siembra'] == null
          ? null
          : DateTime.parse(json['fecha_siembra'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ParcelaToJson(Parcela instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'nombre': instance.nombre,
      'area': instance.area,
      'tipo_cultivo': instance.tipoCultivo,
      'fecha_siembra': instance.fechaSiembra?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
