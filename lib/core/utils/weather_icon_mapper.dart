import 'package:flutter/material.dart';

String iconPathFromWeatherType(String type) {
  const base = 'assets/vectors/icons/';
  switch (type.toLowerCase()) {
    case 'cloudy':
      return '${base}cloudy.svg';
    case 'moonfull':
      return '${base}moon-full.svg';
    case 'sunrise':
    case 'sunny':
      return '${base}sunrise.svg';
    case 'sunset':
      return '${base}sunset.svg';
    default:
      return '${base}fog-day.svg';
  }
}

IconData iconDataFromWeatherType(String type) {
  switch (type.toLowerCase()) {
    case 'cloudy':
      return Icons.wb_cloudy;
    case 'moonfull':
      return Icons.wb_cloudy_outlined;
    case 'sunrise':
    case 'sunny':
      return Icons.wb_sunny;
    case 'sunset':
      return Icons.wb_sunny_outlined;
    default:
      return Icons.wb_twilight;
  }
}
