/// Modelos para alertas meteorológicas

enum AlertType {
  lluvia,
  helada,
  granizo,
  viento,
  sequia,
  temperatura,
  humedad,
}

enum AlertSeverity {
  baja,
  media,
  alta,
}

class WeatherAlert {
  final String id;
  final AlertType tipo;
  final String titulo;
  final String descripcion;
  final AlertSeverity severidad;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final List<String> recomendaciones;
  final bool activa;
  final DateTime? fechaCreacion;

  const WeatherAlert({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.descripcion,
    required this.severidad,
    required this.fechaInicio,
    required this.fechaFin,
    required this.recomendaciones,
    this.activa = true,
    this.fechaCreacion,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      id: json['id'] as String,
      tipo: AlertType.values.firstWhere(
        (e) => e.name == json['tipo'],
        orElse: () => AlertType.lluvia,
      ),
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      severidad: AlertSeverity.values.firstWhere(
        (e) => e.name == json['severidad'],
        orElse: () => AlertSeverity.baja,
      ),
      fechaInicio: DateTime.parse(json['fecha_inicio'] as String),
      fechaFin: DateTime.parse(json['fecha_fin'] as String),
      recomendaciones: List<String>.from(json['recomendaciones'] as List),
      activa: json['activa'] as bool? ?? true,
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo.name,
      'titulo': titulo,
      'descripcion': descripcion,
      'severidad': severidad.name,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'fecha_fin': fechaFin.toIso8601String(),
      'recomendaciones': recomendaciones,
      'activa': activa,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
    };
  }

  bool get isActive {
    final now = DateTime.now();
    return activa && now.isAfter(fechaInicio) && now.isBefore(fechaFin);
  }

  Duration get timeUntilStart {
    final now = DateTime.now();
    if (now.isAfter(fechaInicio)) {
      return Duration.zero;
    }
    return fechaInicio.difference(now);
  }

  Duration get duration {
    return fechaFin.difference(fechaInicio);
  }

  WeatherAlert copyWith({
    String? id,
    AlertType? tipo,
    String? titulo,
    String? descripcion,
    AlertSeverity? severidad,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    List<String>? recomendaciones,
    bool? activa,
    DateTime? fechaCreacion,
  }) {
    return WeatherAlert(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      severidad: severidad ?? this.severidad,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      recomendaciones: recomendaciones ?? this.recomendaciones,
      activa: activa ?? this.activa,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}

/// Extensiones para facilitar el uso de las alertas
extension AlertTypeExtension on AlertType {
  String get displayName {
    switch (this) {
      case AlertType.lluvia:
        return 'Lluvia';
      case AlertType.helada:
        return 'Helada';
      case AlertType.granizo:
        return 'Granizo';
      case AlertType.viento:
        return 'Viento Fuerte';
      case AlertType.sequia:
        return 'Sequía';
      case AlertType.temperatura:
        return 'Temperatura Extrema';
      case AlertType.humedad:
        return 'Humedad';
    }
  }

  String get icon {
    switch (this) {
      case AlertType.lluvia:
        return '🌧️';
      case AlertType.helada:
        return '❄️';
      case AlertType.granizo:
        return '🧊';
      case AlertType.viento:
        return '💨';
      case AlertType.sequia:
        return '🌵';
      case AlertType.temperatura:
        return '🌡️';
      case AlertType.humedad:
        return '💧';
    }
  }
}

extension AlertSeverityExtension on AlertSeverity {
  String get displayName {
    switch (this) {
      case AlertSeverity.baja:
        return 'Baja';
      case AlertSeverity.media:
        return 'Media';
      case AlertSeverity.alta:
        return 'Alta';
    }
  }

  String get description {
    switch (this) {
      case AlertSeverity.baja:
        return 'Monitorear condiciones';
      case AlertSeverity.media:
        return 'Tomar precauciones';
      case AlertSeverity.alta:
        return 'Acción inmediata requerida';
    }
  }
}
