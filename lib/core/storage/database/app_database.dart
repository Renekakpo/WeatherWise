import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const _databaseName = 'location_database.db';
const _databaseVersion = 1;

const _createLocationsTable = '''
CREATE TABLE locations(
  id INTEGER PRIMARY KEY,
  name TEXT,
  region TEXT,
  longitude REAL,
  latitude REAL,
  isFavorite INTEGER,
  useDeviceLocation INTEGER,
  weatherCondition TEXT,
  weatherIconId TEXT,
  currentTemperature REAL,
  minTemperature REAL,
  maxTemperature REAL
)
''';

Future<Database> openAppDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), _databaseName),
    onCreate: (db, version) => db.execute(_createLocationsTable),
    version: _databaseVersion,
  );
}

/// Application sqlite database. Resolved lazily; tests override with an
/// in-memory ffi database via `appDatabaseProvider.overrideWith`.
final appDatabaseProvider = FutureProvider<Database>((_) {
  return openAppDatabase();
});
