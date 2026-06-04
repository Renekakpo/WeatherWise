import 'package:flutter/foundation.dart';

/// Converts wind speed from the unit used by OpenWeather's metric / imperial
/// modes to the unit the UI displays (km/h or kmi/h).
double convertFromMeterToKilometer(bool isImperial, double windSpeed) {
  try {
    if (!isImperial) {
      return windSpeed * 3.6;
    }
    return (windSpeed * 3600) / 1000;
  } catch (e) {
    if (kDebugMode) debugPrint('convertFromMeterToKilometer: $e');
    return windSpeed;
  }
}
