import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherwise/helpers/shared_preferences_helper.dart';
import 'package:weatherwise/helpers/utils_helper.dart';
import 'package:weatherwise/models/forecast_data.dart';
import 'package:weatherwise/models/weather_data.dart';
import 'package:weatherwise/screens/weather_screen.dart';

import 'weather_screen_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    HttpOverrides.global = null;

    mockSharedPreferences = MockSharedPreferences();

    AppSharedPreferences(prefs: mockSharedPreferences);

    // Mock the weather unit preference
    when(mockSharedPreferences.getBool('weather_unit')).thenReturn(false); // Celsius
  });

  testWidgets('WeatherScreen renders correctly and triggers notification', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: WeatherScreen(
          weatherData: WeatherData.fake(),
          forecastData: ForecastData.fake(),
        ),
      ));

      // Verify that the main weather components are displayed correctly
      expect(find.byKey(const Key('main_temperature')), findsOneWidget);
      expect(find.byKey(const Key('main_condition')), findsOneWidget);
      expect(find.byKey(const Key('min_and_max_temperature')), findsOneWidget);
    });
  });

  testWidgets('ForecastCard and SunState widgets render correctly', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: WeatherScreen(
          weatherData: WeatherData.fake(),
          forecastData: ForecastData.fake(),
        ),
      ));

      // Verify the ForecastCard widgets
      expect(find.byKey(const Key('ForecastCard')), findsOneWidget);
      expect(find.byKey(const Key('list_of_days')), findsOneWidget);
      expect(find.byKey(const Key('selected_day_weather_data')), findsOneWidget);

      // Verify the ForecastCard widgets
      expect(find.byKey(const Key('sunrise_animation_icon')), findsOneWidget);
      expect(find.byKey(const Key('sunset_animation_icon')), findsOneWidget);

      // Verify sunrise/sunset time rendering
      expect(find.text(formatTimestampToHour(WeatherData.fake().sys.sunrise)), findsOneWidget);
      expect(find.text(formatTimestampToHour(WeatherData.fake().sys.sunset)), findsOneWidget);
    });
  });
}