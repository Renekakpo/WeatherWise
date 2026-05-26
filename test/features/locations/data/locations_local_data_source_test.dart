import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:weatherwise/features/locations/data/datasources/locations_local_data_source.dart';
import 'package:weatherwise/features/locations/domain/entities/saved_location.dart';

void main() {
  late Database db;
  late LocationsLocalDataSource source;

  SavedLocation makeLocation({
    int? id,
    String name = 'City',
    bool favorite = false,
  }) {
    return SavedLocation(
      id: id,
      name: name,
      region: 'Region',
      latitude: 1.0,
      longitude: 2.0,
      isFavorite: favorite,
      useDeviceLocation: false,
      weatherCondition: 'Clear',
      weatherIconId: '01d',
      currentTemperature: 20.0,
      minTemperature: 15.0,
      maxTemperature: 25.0,
    );
  }

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, _) => db.execute(
        'CREATE TABLE locations(id INTEGER PRIMARY KEY, name TEXT, region TEXT, '
        'longitude REAL, latitude REAL, isFavorite INTEGER, '
        'useDeviceLocation INTEGER, weatherCondition TEXT, weatherIconId TEXT, '
        'currentTemperature REAL, minTemperature REAL, maxTemperature REAL)',
      ),
    );
    source = LocationsLocalDataSource(Future.value(db));
  });

  tearDown(() async {
    await db.close();
  });

  test('insert + getAll round-trips a location', () async {
    await source.insert(makeLocation(name: 'Paris'));
    final list = await source.getAll();
    expect(list, hasLength(1));
    expect(list.first.name, 'Paris');
  });

  test('setFavorite makes exactly one row favorite', () async {
    await source.insert(makeLocation(id: 1, name: 'A', favorite: true));
    await source.insert(makeLocation(id: 2, name: 'B'));

    await source.setFavorite(2);

    final all = await source.getAll();
    expect(all.where((l) => l.isFavorite).map((l) => l.id), [2]);

    final fav = await source.getFavorite();
    expect(fav?.id, 2);
  });

  test('delete removes only the targeted row', () async {
    await source.insert(makeLocation(id: 1, name: 'A'));
    await source.insert(makeLocation(id: 2, name: 'B'));

    await source.delete(1);

    final all = await source.getAll();
    expect(all.map((l) => l.id), [2]);
  });

  test('deleteAll wipes the table', () async {
    await source.insert(makeLocation(id: 1, name: 'A'));
    await source.insert(makeLocation(id: 2, name: 'B'));

    await source.deleteAll();

    final all = await source.getAll();
    expect(all, isEmpty);
  });
}
