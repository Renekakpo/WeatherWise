import 'dart:math';

import '../models/forecast_data.dart';
import '../models/forecast_weather_data.dart';
import '../models/manage_location.dart';

List<ManageLocation> locations = [
  ManageLocation(
    name: "Cotonou",
    region: "Littoral, Benin",
    isFavorite: true,
    useDeviceLocation: true,
    weatherCondition: "cloudy",
    currentTemperature: 27.0,
    minTemperature: 26.0,
    maxTemperature: 32.0,
  ),
  ManageLocation(
    name: "Natitingou",
    region: "Littoral, Benin",
    isFavorite: false,
    useDeviceLocation: false,
    weatherCondition: "Mist",
    currentTemperature: 32.0,
    minTemperature: 27.0,
    maxTemperature: 37.0,
  ),
  ManageLocation(
    name: "Porto-Novo",
    region: "Littoral, Benin",
    isFavorite: false,
    useDeviceLocation: false,
    weatherCondition: "Mist",
    currentTemperature: 32.0,
    minTemperature: 27.0,
    maxTemperature: 37.0,
  ),
  ManageLocation(
    name: "Ouidah",
    region: "Littoral, Benin",
    isFavorite: false,
    useDeviceLocation: false,
    weatherCondition: "Mist",
    currentTemperature: 32.0,
    minTemperature: 27.0,
    maxTemperature: 37.0,
  ),
  ManageLocation(
    name: "Parakou",
    region: "Littoral, Benin",
    isFavorite: false,
    useDeviceLocation: true,
    weatherCondition: "Mist",
    currentTemperature: 32.0,
    minTemperature: 27.0,
    maxTemperature: 37.0,
  ),
  ManageLocation(
    name: "Pobe",
    region: "Littoral, Benin",
    isFavorite: false,
    useDeviceLocation: true,
    weatherCondition: "Mist",
    currentTemperature: 32.0,
    minTemperature: 27.0,
    maxTemperature: 37.0,
  ),
  ManageLocation(
    name: "Grand-Popo",
    region: "Littoral, Benin",
    isFavorite: false,
    useDeviceLocation: true,
    weatherCondition: "Mist",
    currentTemperature: 32.0,
    minTemperature: 27.0,
    maxTemperature: 37.0,
  ),
  ManageLocation(
    name: "Calavi",
    region: "Littoral, Benin",
    isFavorite: false,
    useDeviceLocation: true,
    weatherCondition: "Mist",
    currentTemperature: 32.0,
    minTemperature: 27.0,
    maxTemperature: 37.0,
  ),
  ManageLocation(
    name: "Pahou",
    region: "Littoral, Benin",
    isFavorite: false,
    useDeviceLocation: true,
    weatherCondition: "Mist",
    currentTemperature: 32.0,
    minTemperature: 27.0,
    maxTemperature: 37.0,
  ),
  ManageLocation(
    name: "Allada",
    region: "Littoral, Benin",
    isFavorite: false,
    useDeviceLocation: true,
    weatherCondition: "Mist",
    currentTemperature: 32.0,
    minTemperature: 27.0,
    maxTemperature: 37.0,
  ),
];

List<ForecastWeatherData> generateDummyData() {
  List<ForecastWeatherData> data = [];

  // Assuming today's hours (from 1 AM to 11 PM)
  for (int i = 1; i <= 11; i++) {
    double hour = i.toDouble();
    double temperature = 25.0 + i; // Just for variety, you can replace this with your temperature logic

    String weatherType;
    double raindropProbability = i * 5.0; // Replace with actual logic

    // Vary the weather type based on the hour
    if (i < 6) {
      weatherType = 'Moonfull';
    } else if (i < 8) {
      weatherType = 'Sunrise';
    } else if (i < 18) {
      weatherType = 'Sunny';
    } else if (i < 20) {
      weatherType = 'Sunset';
    } else {
      weatherType = 'Moonfull';
    }

    ForecastWeatherData forecast = ForecastWeatherData(
      hour: hour,
      temperature: temperature,
      weatherType: weatherType,
      raindropProb: raindropProbability,
    );

    data.add(forecast);
  }

  return data;
}

// Get today's date
DateTime today = DateTime.now();
// Create a list of days starting from yesterday
// List of day names starting from yesterday
List<String> days = [
  'Yesterday',
  'Today',
  'Tomorrow',
  for (int i = 2; i < 9; i++) _getDayName(today.add(Duration(days: i)).weekday).substring(0,3),
];

String _getDayName(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'Monday';
    case DateTime.tuesday:
      return 'Tuesday';
    case DateTime.wednesday:
      return 'Wednesday';
    case DateTime.thursday:
      return 'Thursday';
    case DateTime.friday:
      return 'Friday';
    case DateTime.saturday:
      return 'Saturday';
    case DateTime.sunday:
      return 'Sunday';
    default:
      return '';
  }
}

// Generate random forecast data for each day
List<ForecastData> forecastList = List.generate(8, (index) {
  return ForecastData(
    day: days[index],
    minTemp: Random().nextInt(20) + 10.toDouble(),
    maxTemp: Random().nextInt(20) + 20.toDouble(),
    weatherTypeForMinTemp: 'Sunny',
    weatherTypeForMaxTemp: 'Cloudy',
    raindropProb: Random().nextDouble() * 100,
  );
});