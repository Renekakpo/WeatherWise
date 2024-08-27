import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/manage_location.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'location_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE locations(id INTEGER PRIMARY KEY, name TEXT, region TEXT, isFavorite INTEGER, useDeviceLocation INTEGER, weatherCondition TEXT, currentTemperature REAL, minTemperature REAL, maxTemperature REAL)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertLocation(ManageLocation location) async {
    final db = await database;
    await db.insert(
      'locations',
      location.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ManageLocation>> getAllLocations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('locations');

    return List.generate(maps.length, (i) {
      return ManageLocation(
        id: maps[i]['id'],
        name: maps[i]['name'],
        region: maps[i]['region'],
        isFavorite: maps[i]['isFavorite'] == 1,
        useDeviceLocation: maps[i]['useDeviceLocation'] == 1,
        weatherCondition: maps[i]['weatherCondition'],
        currentTemperature: (maps[i]['currentTemperature'] as num).toDouble(),
        minTemperature: (maps[i]['minTemperature'] as num).toDouble(),
        maxTemperature: (maps[i]['maxTemperature'] as num).toDouble(),
      );
    });
  }

  Future<void> deleteAllLocations() async {
    final db = await database;
    await db.delete('locations');
  }

  Future<void> deleteLocation(int id) async {
    final db = await database;
    await db.delete(
      'locations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> setFavoriteLocation(int id) async {
    final db = await database;
    await db.transaction((txn) async {
      // Unset all favorites
      await txn.update(
        'locations',
        {'isFavorite': 0},
      );
      // Set the specific entry as favorite
      await txn.update(
        'locations',
        {'isFavorite': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

}