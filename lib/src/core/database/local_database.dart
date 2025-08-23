import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_initializer.dart';

/// Provider para la base de datos local
final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  return LocalDatabase();
});

/// Servicio de base de datos local SQLite para funcionamiento offline
class LocalDatabase {
  static Database? _database;
  static const String _databaseName = 'agrisoft_local.db';
  static const int _databaseVersion = 1;

  /// Obtiene la instancia de la base de datos
  Future<Database> get database async {
    // Verificar que la base de datos esté inicializada
    if (!DatabaseInitializer.isInitialized) {
      await DatabaseInitializer.initialize();
    }

    _database ??= await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos local
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Crea las tablas iniciales
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE parcelas (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        nombre TEXT NOT NULL,
        area REAL NOT NULL,
        tipo_cultivo TEXT NOT NULL,
        fecha_siembra TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status INTEGER DEFAULT 0,
        local_id TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE labores (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        parcela_id TEXT,
        nombre TEXT NOT NULL,
        descripcion TEXT,
        fecha_realizacion TEXT NOT NULL,
        costo REAL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        sync_status INTEGER DEFAULT 0,
        local_id TEXT,
        FOREIGN KEY (parcela_id) REFERENCES parcelas (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name TEXT NOT NULL,
        record_id TEXT NOT NULL,
        action TEXT NOT NULL,
        data TEXT NOT NULL,
        created_at TEXT NOT NULL,
        retry_count INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  /// Actualiza la base de datos en versiones futuras
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar migraciones futuras aquí
  }

  /// Cierra la base de datos
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  /// Elimina la base de datos (solo para desarrollo/testing)
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  // =====================================================
  // MÉTODOS PARA PARCELAS
  // =====================================================

  /// Inserta una parcela en la base de datos local
  Future<String> insertParcela(Map<String, dynamic> parcela) async {
    final db = await database;
    final localId = DateTime.now().millisecondsSinceEpoch.toString();
    
    parcela['local_id'] = localId;
    parcela['sync_status'] = SyncStatus.pending.index;
    
    await db.insert('parcelas', parcela);
    
    // Agregar a la cola de sincronización
    await _addToSyncQueue('parcelas', localId, 'INSERT', parcela);
    
    return localId;
  }

  /// Obtiene todas las parcelas del usuario
  Future<List<Map<String, dynamic>>> getParcelas(String userId) async {
    final db = await database;
    return await db.query(
      'parcelas',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  /// Actualiza una parcela
  Future<void> updateParcela(String id, Map<String, dynamic> parcela) async {
    final db = await database;
    
    parcela['updated_at'] = DateTime.now().toIso8601String();
    parcela['sync_status'] = SyncStatus.pending.index;
    
    await db.update(
      'parcelas',
      parcela,
      where: 'id = ? OR local_id = ?',
      whereArgs: [id, id],
    );
    
    // Agregar a la cola de sincronización
    await _addToSyncQueue('parcelas', id, 'UPDATE', parcela);
  }

  /// Elimina una parcela
  Future<void> deleteParcela(String id) async {
    final db = await database;
    
    await db.delete(
      'parcelas',
      where: 'id = ? OR local_id = ?',
      whereArgs: [id, id],
    );
    
    // Agregar a la cola de sincronización
    await _addToSyncQueue('parcelas', id, 'DELETE', {'id': id});
  }

  // =====================================================
  // MÉTODOS PARA LABORES
  // =====================================================

  /// Inserta una labor en la base de datos local
  Future<String> insertLabor(Map<String, dynamic> labor) async {
    final db = await database;
    final localId = DateTime.now().millisecondsSinceEpoch.toString();
    
    labor['local_id'] = localId;
    labor['sync_status'] = SyncStatus.pending.index;
    
    await db.insert('labores', labor);
    
    // Agregar a la cola de sincronización
    await _addToSyncQueue('labores', localId, 'INSERT', labor);
    
    return localId;
  }

  /// Obtiene todas las labores del usuario
  Future<List<Map<String, dynamic>>> getLabores(String userId, {String? parcelaId}) async {
    final db = await database;
    
    String where = 'user_id = ?';
    List<String> whereArgs = [userId];
    
    if (parcelaId != null) {
      where += ' AND parcela_id = ?';
      whereArgs.add(parcelaId);
    }
    
    return await db.query(
      'labores',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'fecha_realizacion DESC',
    );
  }

  // =====================================================
  // COLA DE SINCRONIZACIÓN
  // =====================================================

  /// Agrega un elemento a la cola de sincronización
  Future<void> _addToSyncQueue(String tableName, String recordId, String action, Map<String, dynamic> data) async {
    final db = await database;
    
    await db.insert('sync_queue', {
      'table_name': tableName,
      'record_id': recordId,
      'action': action,
      'data': data.toString(), // En producción usar JSON
      'created_at': DateTime.now().toIso8601String(),
      'retry_count': 0,
    });
  }

  /// Obtiene elementos pendientes de sincronización
  Future<List<Map<String, dynamic>>> getPendingSyncItems() async {
    final db = await database;
    return await db.query(
      'sync_queue',
      orderBy: 'created_at ASC',
    );
  }

  /// Elimina un elemento de la cola de sincronización
  Future<void> removeSyncItem(int syncId) async {
    final db = await database;
    await db.delete(
      'sync_queue',
      where: 'id = ?',
      whereArgs: [syncId],
    );
  }

  /// Incrementa el contador de reintentos
  Future<void> incrementRetryCount(int syncId) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE sync_queue SET retry_count = retry_count + 1 WHERE id = ?',
      [syncId],
    );
  }

  // =====================================================
  // CONFIGURACIONES
  // =====================================================

  /// Guarda una configuración
  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {
        'key': key,
        'value': value,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Obtiene una configuración
  Future<String?> getSetting(String key) async {
    final db = await database;
    final result = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    
    return result.isNotEmpty ? result.first['value'] as String : null;
  }
}

/// Estados de sincronización
enum SyncStatus {
  synced,    // 0 - Sincronizado
  pending,   // 1 - Pendiente de sincronización
  error,     // 2 - Error en sincronización
}
