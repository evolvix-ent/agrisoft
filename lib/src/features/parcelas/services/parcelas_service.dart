import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/parcela.dart';
import '../../../core/database/local_database.dart';
import '../../../core/services/connectivity_service.dart';

/// Provider para el servicio de parcelas
final parcelasServiceProvider = Provider<ParcelasService>((ref) {
  final localDb = ref.read(localDatabaseProvider);
  final connectivityService = ref.read(connectivityServiceProvider);
  return ParcelasService(localDb, connectivityService);
});

/// Servicio para gestionar las operaciones CRUD de parcelas (offline-first)
class ParcelasService {
  final LocalDatabase _localDb;
  final ConnectivityService _connectivityService;
  final SupabaseClient _supabase = Supabase.instance.client;

  ParcelasService(this._localDb, this._connectivityService);

  /// Obtiene todas las parcelas del usuario autenticado (offline-first)
  Future<List<Parcela>> getParcelas() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      // Siempre obtener de la base de datos local primero
      final localParcelas = await _localDb.getParcelas(userId);
      final parcelas = localParcelas.map<Parcela>((json) => Parcela.fromJson(json)).toList();

      // Si hay conexión, intentar sincronizar en segundo plano
      final hasConnection = await _connectivityService.hasInternetConnection();
      if (hasConnection) {
        _syncParcelasInBackground(userId);
      }

      return parcelas;
    } catch (e) {
      throw Exception('Error al obtener parcelas: $e');
    }
  }

  /// Sincroniza parcelas en segundo plano
  Future<void> _syncParcelasInBackground(String userId) async {
    try {
      final response = await _supabase
          .from('parcelas')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      // Actualizar base de datos local con datos del servidor
      for (final parcelaData in response) {
        parcelaData['sync_status'] = SyncStatus.synced.index;
        await _localDb.insertParcela(parcelaData);
      }
    } catch (e) {
      // Error silencioso en sincronización de fondo
      print('Error en sincronización de fondo: $e');
    }
  }

  /// Obtiene una parcela específica por su ID
  Future<Parcela?> getParcela(String id) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      final response = await _supabase
          .from('parcelas')
          .select()
          .eq('id', id)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return Parcela.fromJson(response);
    } catch (e) {
      throw Exception('Error al obtener parcela: $e');
    }
  }

  /// Crea una nueva parcela (offline-first)
  Future<Parcela> insertParcela(Parcela parcela) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      // Crear parcela con el user_id del usuario autenticado
      final parcelaData = parcela.toInsertMap();
      parcelaData['user_id'] = userId;
      parcelaData['created_at'] = DateTime.now().toIso8601String();
      parcelaData['updated_at'] = DateTime.now().toIso8601String();

      // Guardar en base de datos local inmediatamente
      final localId = await _localDb.insertParcela(parcelaData);

      // Crear parcela con ID local
      final parcelaLocal = parcela.copyWith(
        id: localId,
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Si hay conexión, intentar sincronizar inmediatamente
      final hasConnection = await _connectivityService.hasInternetConnection();
      if (hasConnection) {
        try {
          final response = await _supabase
              .from('parcelas')
              .insert(parcelaData)
              .select()
              .single();

          // Actualizar con ID del servidor
          await _localDb.updateParcela(localId, {
            'id': response['id'],
            'sync_status': SyncStatus.synced.index,
          });

          return Parcela.fromJson(response);
        } catch (e) {
          // Si falla la sincronización, mantener la versión local
          print('Error en sincronización inmediata, se guardó localmente: $e');
        }
      }

      return parcelaLocal;
    } catch (e) {
      throw Exception('Error al crear parcela: $e');
    }
  }

  /// Actualiza una parcela existente
  Future<Parcela> updateParcela(String id, Parcela parcela) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      final response = await _supabase
          .from('parcelas')
          .update(parcela.toUpdateMap())
          .eq('id', id)
          .eq('user_id', userId)
          .select()
          .single();

      return Parcela.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar parcela: $e');
    }
  }

  /// Elimina una parcela
  Future<void> deleteParcela(String id) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      await _supabase
          .from('parcelas')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Error al eliminar parcela: $e');
    }
  }

  /// Obtiene estadísticas de parcelas del usuario
  Future<Map<String, dynamic>> getEstadisticasParcelas() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      final parcelas = await getParcelas();

      // Calcular estadísticas
      final totalParcelas = parcelas.length;
      final areaTotal = parcelas.fold<double>(0, (sum, p) => sum + p.area);
      
      // Contar por tipo de cultivo
      final Map<String, int> cultivosPorTipo = {};
      for (final parcela in parcelas) {
        cultivosPorTipo[parcela.tipoCultivo] = 
            (cultivosPorTipo[parcela.tipoCultivo] ?? 0) + 1;
      }

      // Parcelas sembradas (con fecha de siembra)
      final parcelasSembradas = parcelas.where((p) => p.fechaSiembra != null).length;

      return {
        'total_parcelas': totalParcelas,
        'area_total': areaTotal,
        'parcelas_sembradas': parcelasSembradas,
        'cultivos_por_tipo': cultivosPorTipo,
        'promedio_area': totalParcelas > 0 ? areaTotal / totalParcelas : 0.0,
      };
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  /// Busca parcelas por nombre o tipo de cultivo
  Future<List<Parcela>> buscarParcelas(String query) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      final response = await _supabase
          .from('parcelas')
          .select()
          .eq('user_id', userId)
          .or('nombre.ilike.%$query%,tipo_cultivo.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Parcela.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar parcelas: $e');
    }
  }

  /// Obtiene parcelas por tipo de cultivo
  Future<List<Parcela>> getParcelasPorTipoCultivo(String tipoCultivo) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      final response = await _supabase
          .from('parcelas')
          .select()
          .eq('user_id', userId)
          .eq('tipo_cultivo', tipoCultivo)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Parcela.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener parcelas por tipo de cultivo: $e');
    }
  }

  /// Stream para escuchar cambios en tiempo real de las parcelas
  Stream<List<Parcela>> watchParcelas() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return Stream.error('Usuario no autenticado');
    }

    return _supabase
        .from('parcelas')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Parcela.fromJson(json)).toList());
  }

  /// Valida si el nombre de la parcela ya existe para el usuario
  Future<bool> existeNombreParcela(String nombre, {String? excludeId}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      var query = _supabase
          .from('parcelas')
          .select('id')
          .eq('user_id', userId)
          .eq('nombre', nombre);

      if (excludeId != null) {
        query = query.neq('id', excludeId);
      }

      final response = await query.maybeSingle();
      return response != null;
    } catch (e) {
      throw Exception('Error al validar nombre de parcela: $e');
    }
  }
}
