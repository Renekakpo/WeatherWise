import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:weatherwise/helpers/database_helper.dart';
import 'package:weatherwise/models/manage_location.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    sqfliteFfiInit();
    // Change the default factory for unit testing calls for SQFlite
    databaseFactory = databaseFactoryFfi;
    databaseHelper = DatabaseHelper();
  });

  test('Database is created', () async {
    final db = await databaseHelper.database;
    expect(db, isA<Database>());
  });

  test('Insert and retrieve location', () async {
    final location = ManageLocation(
      id: 1,
      name: 'Test Location',
      region: 'Test Region',
      longitude: 123.456,
      latitude: 78.910,
      isFavorite: true,
      useDeviceLocation: true,
      weatherCondition: 'Sunny',
      weatherIconId: '01d',
      currentTemperature: 25.0,
      minTemperature: 20.0,
      maxTemperature: 30.0,
    );

    await databaseHelper.insertLocation(location);

    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('locations');

    expect(maps.length, 2);
    expect(maps.first['name'], 'Test Location');
  });

  test('Get all locations', () async {
    final location1 = ManageLocation(
      id: 1,
      name: 'Location 1',
      region: 'Region 1',
      longitude: 123.456,
      latitude: 78.910,
      isFavorite: true,
      useDeviceLocation: true,
      weatherCondition: 'Sunny',
      weatherIconId: '01d',
      currentTemperature: 25.0,
      minTemperature: 20.0,
      maxTemperature: 30.0,
    );

    final location2 = ManageLocation(
      id: 2,
      name: 'Location 2',
      region: 'Region 2',
      longitude: 223.456,
      latitude: 88.910,
      isFavorite: false,
      useDeviceLocation: false,
      weatherCondition: 'Cloudy',
      weatherIconId: '02d',
      currentTemperature: 20.0,
      minTemperature: 15.0,
      maxTemperature: 25.0,
    );

    await databaseHelper.insertLocation(location1);
    await databaseHelper.insertLocation(location2);

    final locations = await databaseHelper.getAllLocations();

    expect(locations.length, 2);
    expect(locations[0].name, 'Location 1');
    expect(locations[1].name, 'Location 2');
  });

  test('Delete all locations', () async {
    await databaseHelper.deleteAllLocations();

    final locations = await databaseHelper.getAllLocations();

    expect(locations.length, 0);
  });

  test('Delete a specific location', () async {
    final location = ManageLocation(
      id: 1,
      name: 'Location to Delete',
      region: 'Region',
      longitude: 123.456,
      latitude: 78.910,
      isFavorite: true,
      useDeviceLocation: true,
      weatherCondition: 'Sunny',
      weatherIconId: '01d',
      currentTemperature: 25.0,
      minTemperature: 20.0,
      maxTemperature: 30.0,
    );

    await databaseHelper.insertLocation(location);
    await databaseHelper.deleteLocation(1);

    final locations = await databaseHelper.getAllLocations();

    expect(locations.length, 0);
  });

  test('Set favorite location', () async {
    final location1 = ManageLocation(
      id: 1,
      name: 'Location 1',
      region: 'Region 1',
      longitude: 123.456,
      latitude: 78.910,
      isFavorite: false,
      useDeviceLocation: true,
      weatherCondition: 'Sunny',
      weatherIconId: '01d',
      currentTemperature: 25.0,
      minTemperature: 20.0,
      maxTemperature: 30.0,
    );

    final location2 = ManageLocation(
      id: 2,
      name: 'Location 2',
      region: 'Region 2',
      longitude: 223.456,
      latitude: 88.910,
      isFavorite: false,
      useDeviceLocation: false,
      weatherCondition: 'Cloudy',
      weatherIconId: '02d',
      currentTemperature: 20.0,
      minTemperature: 15.0,
      maxTemperature: 25.0,
    );

    await databaseHelper.insertLocation(location1);
    await databaseHelper.insertLocation(location2);

    await databaseHelper.setFavoriteLocation(2);

    final favoriteLocation = await databaseHelper.getLocalFavoriteLocation();

    expect(favoriteLocation?.id, 2);
    expect(favoriteLocation?.isFavorite, true);
  });

  test('Get local favorite location', () async {
    final location = ManageLocation(
      id: 1,
      name: 'Favorite Location',
      region: 'Region',
      longitude: 123.456,
      latitude: 78.910,
      isFavorite: true,
      useDeviceLocation: true,
      weatherCondition: 'Sunny',
      weatherIconId: '01d',
      currentTemperature: 25.0,
      minTemperature: 20.0,
      maxTemperature: 30.0,
    );

    await databaseHelper.insertLocation(location);

    final favoriteLocation = await databaseHelper.getLocalFavoriteLocation();

    expect(favoriteLocation?.name, 'Favorite Location');
  });

}
