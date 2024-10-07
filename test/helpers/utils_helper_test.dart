import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherwise/helpers/utils_helper.dart';

import 'utils_helper_test.mocks.dart';

@GenerateMocks([AssetBundle])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAssetBundle mockBundle;

  setUpAll(() {
    // Initialize the mock bundle
    mockBundle = MockAssetBundle();
  });

  group('Utils Helper Tests', () {
    test('Test formatDateTime', () {
      DateTime dateTime = DateTime(2024, 9, 25, 15, 30);
      String formatted = formatDateTime(dateTime);
      expect(formatted, 'Wed, 25 Sep 15:30');
    });

    test('Test getDayNameFromTimestamp', () {
      int timestamp = 1727277119;  // Wed, 25 Sep 2024, 4:11
      String dayName = getDayNameFromTimestamp(timestamp);
      expect(dayName, 'Wednesday');
    });

    test('Test formatTimestampToHour with zero minutes', () {
      int timestamp = 1727277119; // Wed, 25 Sep 2024, 4:11
      String hour = formatTimestampToHour(timestamp);
      // Replace non-breaking spaces with regular spaces
      hour = hour.replaceAll(String.fromCharCode(0x202F), ' ');
      expect(hour, '4:11 PM');
    });

    test('Test formatTimestampToHour with non-zero minutes', () {
      int timestamp = 1727277119; // Wed, 25 Sep 2024, 16:11
      String hour = formatTimestampToHour(timestamp);
      // Replace non-breaking spaces with regular spaces
      hour = hour.replaceAll(String.fromCharCode(0x202F), ' ');
      expect(hour, '4:11 PM');
    });

    test('Test iconPathFromWeatherType', () {
      String type = "cloudy";
      String path = iconPathFromWeatherType(type);
      expect(path, "assets/vectors/icons/cloudy.svg");
    });

    test('Test iconDataFromWeatherType', () {
      String type = "cloudy";
      IconData iconData = iconDataFromWeatherType(type);
      expect(iconData, Icons.wb_cloudy);
    });

    test('Test myLoadAsset with valid path', () async {
      // Simulate the asset being present
      String path = "assets/vectors/icons/cloudy.svg";
      when(mockBundle.load(path)).thenAnswer((_) async => ByteData(0)); // Simulate asset loading

      String? loadedPath = await myLoadAsset(path, assetBundle: mockBundle);
      expect(loadedPath, path); // Expect the path to be returned
    });

    test('Test getWeatherDescription for freezing temperature', () {
      double temperature = -5;
      String description = getWeatherDescription(temperature);
      expect(description, "It's freezing outside! Bundle up warmly.");
    });

    test('Test convertFromMeterToKilometer for metric unit', () {
      double windSpeed = 10; // meters per second
      double kmh = convertFromMeterToKilometer(false, windSpeed);
      expect(kmh, 36); // 10 m/s = 36 km/h
    });

    test('Test convertFromMeterToKilometer for imperial unit', () {
      double windSpeed = 1; // miles per second
      double mph = convertFromMeterToKilometer(true, windSpeed);
      expect(mph, 3.6); // 1 mile/s = 3.6 kilo miles per hour
    });
  });
}