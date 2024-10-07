import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherwise/helpers/shared_preferences_helper.dart';

// Mock class for SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized

  late MockSharedPreferences mockSharedPreferences;
  late AppSharedPreferences appSharedPreferences;

  setUp(() async {
    // Initialize the mock object
    mockSharedPreferences = MockSharedPreferences();

    // Create AppSharedPreferences with mockSharedPreferences
    appSharedPreferences = AppSharedPreferences(prefs: mockSharedPreferences);
  });

  group('AppSharedPreferences', () {
    test('should get weather unit (default false)', () {
      // Arrange
      when(() => mockSharedPreferences.getBool('weather_unit'))
          .thenReturn(false);

      // Act
      final result = appSharedPreferences.getWeatherUnit();

      // Assert
      expect(result, false);
      verify(() => mockSharedPreferences.getBool('weather_unit')).called(1);
    });

    test('should set weather unit', () async {
      // Act
      when(() => mockSharedPreferences.setBool('weather_unit', true))
          .thenAnswer((_) async => true);

      // Act
      await appSharedPreferences.setWeatherUnit(true);  // Await the method call

      // Assert
      verify(() => mockSharedPreferences.setBool('weather_unit', true)).called(1);
    });

    test('should get auto refresh setting (default 0)', () {
      // Arrange
      when(() => mockSharedPreferences.getInt('auto_refresh_app'))
          .thenReturn(0);

      // Act
      final result = appSharedPreferences.getAppAutoRefreshSetting();

      // Assert
      expect(result, 0);
      verify(() => mockSharedPreferences.getInt('auto_refresh_app')).called(1);
    });

    test('should set auto refresh setting', () async {
      // Arrange: Make sure the mocked setInt returns a Future<bool>
      when(() => mockSharedPreferences.setInt('auto_refresh_app', 30))
          .thenAnswer((_) async => true);

      // Act
      appSharedPreferences.setAppAutoRefreshSetting(30);

      // Assert
      verify(() => mockSharedPreferences.setInt('auto_refresh_app', 30)).called(1);
    });

    test('should get auto refresh on go setting (default false)', () {
      // Arrange
      when(() => mockSharedPreferences.getBool('auto_refresh_app_on_go'))
          .thenReturn(false);

      // Act
      final result = appSharedPreferences.getAppAutoRefreshOnGoSetting();

      // Assert
      expect(result, false);
      verify(() => mockSharedPreferences.getBool('auto_refresh_app_on_go')).called(1);
    });

    test('should set auto refresh on go setting', () async {
      // Arrange: Make sure the mocked setInt returns a Future<bool>
      when(() => mockSharedPreferences.setBool('auto_refresh_app_on_go', true))
          .thenAnswer((_) async => true);

      // Act
      appSharedPreferences.setAppAutoRefreshOnGoSetting(true);

      // Assert
      verify(() => mockSharedPreferences.setBool('auto_refresh_app_on_go', true)).called(1);
    });
  });
}