import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:weatherwise/helpers/database_helper.dart';
import 'package:weatherwise/helpers/location_helper.dart';
import 'package:weatherwise/helpers/shared_preferences_helper.dart';
import 'package:weatherwise/models/forecast_data.dart';
import 'package:weatherwise/models/weather_data.dart';
import 'package:weatherwise/network/weather_api_helper.dart';
import 'package:weatherwise/screens/home_screen.dart';
import 'package:weatherwise/screens/weather_screen.dart';

import 'home_screen_test.mocks.dart';

@GenerateMocks([SharedPreferences, AppSharedPreferences, DatabaseHelper, WeatherApiHelper, NavigatorObserver, LocationHelper])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel permissionsChannel = MethodChannel('flutter.baseflow.com/permissions/methods');

  late MockAppSharedPreferences mockAppSharedPreferences;
  late MockSharedPreferences mockSharedPreferences;
  late MockNavigatorObserver mockNavigatorObserver;
  late MockWeatherApiHelper mockWeatherApiHelper;
  late MockDatabaseHelper mockDatabaseHelper;
  late MockLocationHelper mockLocationHelper;

  setUpAll(() async {
    HttpOverrides.global = null;

    mockAppSharedPreferences = MockAppSharedPreferences();
    mockSharedPreferences = MockSharedPreferences();
    mockNavigatorObserver = MockNavigatorObserver();
    mockWeatherApiHelper = MockWeatherApiHelper();
    mockDatabaseHelper = MockDatabaseHelper();
    mockLocationHelper = MockLocationHelper();

    AppSharedPreferences(prefs: mockSharedPreferences);
    // Change the default factory for unit testing calls for SQFlite
    databaseFactory = databaseFactoryFfi;

    // Load the environment variables before running tests
    await dotenv.load(fileName: ".env");

    when(mockNavigatorObserver.didPush(any, any)).thenReturn(null);
    when(mockNavigatorObserver.didPop(any, any)).thenReturn(null);
    when(mockNavigatorObserver.navigator).thenReturn(null);
    when(mockSharedPreferences.getBool('weather_unit')).thenReturn(true);
    when(mockAppSharedPreferences.getAppAutoRefreshOnGoSetting()).thenReturn(false);

    permissionsChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'checkPermissionStatus') {
        return 1; // Mock permission granted
      }
      return null;
    });
  });

  testWidgets('should display loader while fetching location', (WidgetTester tester) async {
    // Arrange
    when(mockAppSharedPreferences.getWeatherUnit()).thenReturn(false); // Metric units
    when(mockDatabaseHelper.getLocalFavoriteLocation()).thenAnswer((_) async => null);
    when(mockWeatherApiHelper.getCurrentWeatherData(any, any, any))
        .thenAnswer((_) async => null);

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          databaseHelper: mockDatabaseHelper,
          preferences: mockAppSharedPreferences,
          weatherApiHelper: mockWeatherApiHelper,
        ),
      ),
    );

    // Act: Wait for the widget to settle
    await tester.pump();

    // Assert: Ensure the loader is displayed initially
    expect(find.byKey(const Key('lottie loader')), findsOneWidget);
    expect(find.byType(Lottie), findsOneWidget);
  });

  testWidgets('should display weather data after fetching', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Arrange
      when(mockAppSharedPreferences.getWeatherUnit()).thenReturn(false); // Metric units
      when(mockDatabaseHelper.getLocalFavoriteLocation()).thenAnswer((_) async => null);
      when(mockLocationHelper.getCurrentPosition()).thenAnswer((_) async => Position(
          longitude: 1.5890,
          latitude: 6.6111,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          heading: 0.0,
          floor: 0,
          altitudeAccuracy:  0.0,
          headingAccuracy: 0.0)
      );
      when(mockWeatherApiHelper.getCurrentWeatherData(any, any, any)).thenAnswer(
            (_) async => WeatherData.fake(),
      );
      when(mockWeatherApiHelper.getForecastData(any, any, any))
          .thenAnswer((_) async => ForecastData.fake());
      when(mockLocationHelper.isLocationServiceEnabled()).thenAnswer((_) async => true);

      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            databaseHelper: mockDatabaseHelper,
            preferences: mockAppSharedPreferences,
            weatherApiHelper: mockWeatherApiHelper,
            locationHelper: mockLocationHelper,
          ),
        ),
      );

      // Act: Wait for weather data to load
      await tester.pump();

      // Assert: Ensure the weather screen is displayed
      expect(find.byType(WeatherScreen), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);
    });
  });

  testWidgets('should show location service disabled dialog', (WidgetTester tester) async {
    // Arrange
    when(mockAppSharedPreferences.getWeatherUnit()).thenReturn(false); // Metric units
    when(mockDatabaseHelper.getLocalFavoriteLocation()).thenAnswer((_) async => null);
    when(mockWeatherApiHelper.getCurrentWeatherData(any, any, any))
        .thenAnswer((_) async => null);

    // Simulate location services being disabled
    when(mockLocationHelper.isLocationServiceEnabled()).thenAnswer((_) async => false);

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          databaseHelper: mockDatabaseHelper,
          preferences: mockAppSharedPreferences,
          weatherApiHelper: mockWeatherApiHelper,
          locationHelper: mockLocationHelper,
        ),
      ),
    );

    // Act: Wait for the dialog to show up
    await tester.pump();

    // Assert: Check if the dialog is displayed
    // expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byKey(const Key('Weather details access')), findsOneWidget);
  });

}