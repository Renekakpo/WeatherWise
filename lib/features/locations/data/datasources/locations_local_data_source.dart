import 'package:sqflite/sqflite.dart';

import '../../domain/entities/saved_location.dart';

class LocationsLocalDataSource {
  LocationsLocalDataSource(this._database);

  final Future<Database> _database;

  static const _table = 'locations';

  Future<List<SavedLocation>> getAll() async {
    final db = await _database;
    final rows = await db.query(_table);
    return rows.map(_fromRow).toList();
  }

  Future<SavedLocation?> getFavorite() async {
    final db = await _database;
    final rows = await db.query(
      _table,
      where: 'isFavorite = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  Future<void> insert(SavedLocation location) async {
    final db = await _database;
    await db.insert(
      _table,
      _toMap(location),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    final db = await _database;
    await db.delete(_table);
  }

  Future<void> setFavorite(int id) async {
    final db = await _database;
    await db.transaction((txn) async {
      await txn.update(_table, {'isFavorite': 0});
      await txn.update(
        _table,
        {'isFavorite': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  Map<String, dynamic> _toMap(SavedLocation l) => {
        if (l.id != null) 'id': l.id,
        'name': l.name,
        'region': l.region,
        'latitude': l.latitude,
        'longitude': l.longitude,
        'isFavorite': l.isFavorite ? 1 : 0,
        'useDeviceLocation': l.useDeviceLocation ? 1 : 0,
        'weatherCondition': l.weatherCondition,
        'weatherIconId': l.weatherIconId,
        'currentTemperature': l.currentTemperature,
        'minTemperature': l.minTemperature,
        'maxTemperature': l.maxTemperature,
      };

  SavedLocation _fromRow(Map<String, dynamic> row) => SavedLocation(
        id: row['id'] as int?,
        name: row['name'] as String,
        region: row['region'] as String,
        latitude: (row['latitude'] as num).toDouble(),
        longitude: (row['longitude'] as num).toDouble(),
        isFavorite: row['isFavorite'] == 1,
        useDeviceLocation: row['useDeviceLocation'] == 1,
        weatherCondition: row['weatherCondition'] as String,
        weatherIconId: row['weatherIconId'] as String,
        currentTemperature: (row['currentTemperature'] as num).toDouble(),
        minTemperature: (row['minTemperature'] as num).toDouble(),
        maxTemperature: (row['maxTemperature'] as num).toDouble(),
      );
}
