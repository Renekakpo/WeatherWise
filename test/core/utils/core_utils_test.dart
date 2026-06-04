import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weatherwise/core/utils/date_formatter.dart';
import 'package:weatherwise/core/utils/unit_converter.dart';
import 'package:weatherwise/core/utils/weather_description.dart';
import 'package:weatherwise/core/utils/weather_icon_mapper.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  group('date_formatter', () {
    test('formatDateTime returns the expected pattern', () {
      final formatted = formatDateTime(DateTime(2024, 6, 15, 9, 30));
      expect(formatted, matches(r'^.*, 15 [A-Za-z\.]+ 9:30$'));
    });

    test('getDayNameFromTimestamp returns the local weekday', () {
      final ts = DateTime(2024, 6, 15).millisecondsSinceEpoch ~/ 1000;
      expect(getDayNameFromTimestamp(ts), 'Saturday');
    });

    test('formatTimestampToHour drops minutes when zero', () {
      final ts = DateTime(2024, 6, 15, 14).millisecondsSinceEpoch ~/ 1000;
      expect(formatTimestampToHour(ts), matches(RegExp(r'^2:00\s?PM$')));
    });

    test('formatTimestampToHour keeps minutes when non-zero', () {
      final ts = DateTime(2024, 6, 15, 14, 45).millisecondsSinceEpoch ~/ 1000;
      expect(formatTimestampToHour(ts), matches(RegExp(r'^2:45\s?PM$')));
    });
  });

  group('weather_icon_mapper', () {
    test('iconPathFromWeatherType returns the expected asset', () {
      expect(iconPathFromWeatherType('cloudy'), 'assets/vectors/icons/cloudy.svg');
      expect(iconPathFromWeatherType('sunny'), 'assets/vectors/icons/sunrise.svg');
      expect(iconPathFromWeatherType('unknown'), 'assets/vectors/icons/fog-day.svg');
    });

    test('iconDataFromWeatherType returns the expected Icons', () {
      expect(iconDataFromWeatherType('cloudy'), Icons.wb_cloudy);
      expect(iconDataFromWeatherType('sunset'), Icons.wb_sunny_outlined);
      expect(iconDataFromWeatherType('unknown'), Icons.wb_twilight);
    });
  });

  group('weather_description', () {
    test('returns sensible text across the temperature range', () {
      expect(getWeatherDescription(-5), contains('freezing'));
      expect(getWeatherDescription(5), contains('cold'));
      expect(getWeatherDescription(15), contains('cool'));
      expect(getWeatherDescription(25), contains('warm'));
      expect(getWeatherDescription(35), contains('hot'));
      expect(getWeatherDescription(42), contains('extremely hot'));
    });
  });

  group('unit_converter', () {
    test('metric converts m/s to km/h', () {
      expect(convertFromMeterToKilometer(false, 10), closeTo(36.0, 0.01));
    });

    test('imperial converts miles/s to kmiles/h', () {
      expect(convertFromMeterToKilometer(true, 1), closeTo(3.6, 0.01));
    });
  });
}
