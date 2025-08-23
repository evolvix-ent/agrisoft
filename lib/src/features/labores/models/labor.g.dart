// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Labor _$LaborFromJson(Map<String, dynamic> json) => Labor(
      id: json['id'] as String,
      parcelaId: json['parcela_id'] as String,
      userId: json['user_id'] as String,
      tipo: json['tipo'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      descripcion: json['descripcion'] as String?,
      producto: json['producto'] as String?,
      cantidad: (json['cantidad'] as num?)?.toDouble(),
      costo: (json['costo'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$LaborToJson(Labor instance) => <String, dynamic>{
      'id': instance.id,
      'parcela_id': instance.parcelaId,
      'user_id': instance.userId,
      'tipo': instance.tipo,
      'fecha': instance.fecha.toIso8601String(),
      'descripcion': instance.descripcion,
      'producto': instance.producto,
      'cantidad': instance.cantidad,
      'costo': instance.costo,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
