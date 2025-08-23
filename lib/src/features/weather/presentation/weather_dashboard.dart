import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme.dart';
import '../../../core/responsive/responsive_breakpoints.dart';
import '../models/weather_alert.dart';

/// Dashboard del clima con alertas y pronósticos
class WeatherDashboard extends ConsumerWidget {
  const WeatherDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima y Alertas'),
        backgroundColor: const Color(0xFF3742FA).withValues(alpha: 0.1),
        foregroundColor: const Color(0xFF3742FA),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveBreakpoints.getHorizontalPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clima actual
            _buildCurrentWeather(context),
            SizedBox(height: ResponsiveBreakpoints.getSpacing(context, multiplier: 3)),

            // Alertas activas
            _buildActiveAlerts(context),
            SizedBox(height: ResponsiveBreakpoints.getSpacing(context, multiplier: 3)),

            // Pronóstico 7 días
            _buildWeeklyForecast(context),
            SizedBox(height: ResponsiveBreakpoints.getSpacing(context, multiplier: 3)),

            // Recomendaciones agrícolas
            _buildAgricultureRecommendations(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeather(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3742FA), Color(0xFF5352ED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clima Actual',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Actualizado hace 15 min',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.wb_sunny,
                color: Colors.yellow,
                size: 48,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildWeatherMetric(
                  context,
                  'Temperatura',
                  '24°C',
                  Icons.thermostat,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildWeatherMetric(
                  context,
                  'Humedad',
                  '68%',
                  Icons.water_drop,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildWeatherMetric(
                  context,
                  'Viento',
                  '12 km/h',
                  Icons.air,
                  Colors.grey,
                ),
              ),
              Expanded(
                child: _buildWeatherMetric(
                  context,
                  'Precipitación',
                  '0 mm',
                  Icons.grain,
                  Colors.lightBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherMetric(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
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

  Widget _buildActiveAlerts(BuildContext context) {
    final alerts = [
      WeatherAlert(
        id: '1',
        tipo: AlertType.lluvia,
        titulo: 'Lluvia Intensa Próxima',
        descripcion: 'Se esperan lluvias intensas en las próximas 6 horas',
        severidad: AlertSeverity.media,
        fechaInicio: DateTime.now().add(const Duration(hours: 2)),
        fechaFin: DateTime.now().add(const Duration(hours: 8)),
        recomendaciones: [
          'Proteger cultivos sensibles',
          'Revisar sistemas de drenaje',
          'Posponer aplicaciones foliares'
        ],
      ),
      WeatherAlert(
        id: '2',
        tipo: AlertType.helada,
        titulo: 'Riesgo de Helada',
        descripcion: 'Temperaturas bajo 0°C esperadas mañana en la madrugada',
        severidad: AlertSeverity.alta,
        fechaInicio: DateTime.now().add(const Duration(hours: 18)),
        fechaFin: DateTime.now().add(const Duration(hours: 24)),
        recomendaciones: [
          'Activar sistemas de protección contra heladas',
          'Cubrir plantas sensibles',
          'Monitorear temperatura constantemente'
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alertas Activas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...alerts.map((alert) => _buildAlertCard(context, alert)),
      ],
    );
  }

  Widget _buildAlertCard(BuildContext context, WeatherAlert alert) {
    Color alertColor;
    IconData alertIcon;
    
    switch (alert.severidad) {
      case AlertSeverity.baja:
        alertColor = Colors.yellow.shade600;
        alertIcon = Icons.info;
        break;
      case AlertSeverity.media:
        alertColor = Colors.orange.shade600;
        alertIcon = Icons.warning;
        break;
      case AlertSeverity.alta:
        alertColor = Colors.red.shade600;
        alertIcon = Icons.error;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: alertColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: alertColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(alertIcon, color: alertColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  alert.titulo,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: alertColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            alert.descripcion,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Recomendaciones:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          ...alert.recomendaciones.map((rec) => Padding(
            padding: const EdgeInsets.only(left: 16, top: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: alertColor)),
                Expanded(child: Text(rec)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildWeeklyForecast(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pronóstico 7 Días',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              return _buildDayForecast(context, date, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayForecast(BuildContext context, DateTime date, int index) {
    final isToday = index == 0;
    final dayName = isToday ? 'Hoy' : _getDayName(date.weekday);
    
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isToday ? AppTheme.primaryCoral : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isToday ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            _getWeatherIcon(index),
            color: isToday ? Colors.white : Colors.blue.shade600,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            '${20 + index}°',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isToday ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgricultureRecommendations(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.agriculture, color: Colors.green.shade700),
              const SizedBox(width: 12),
              Text(
                'Recomendaciones Agrícolas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRecommendationItem(
            context,
            'Riego',
            'Condiciones ideales para riego por aspersión',
            Icons.water_drop,
            Colors.blue,
          ),
          _buildRecommendationItem(
            context,
            'Fumigación',
            'Evitar aplicaciones por viento fuerte',
            Icons.bug_report,
            Colors.orange,
          ),
          _buildRecommendationItem(
            context,
            'Cosecha',
            'Excelentes condiciones para cosecha',
            Icons.grass,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return days[weekday - 1];
  }

  IconData _getWeatherIcon(int index) {
    const icons = [
      Icons.wb_sunny,
      Icons.cloud,
      Icons.grain,
      Icons.wb_sunny,
      Icons.cloud,
      Icons.wb_sunny,
      Icons.cloud,
    ];
    return icons[index % icons.length];
  }
}
