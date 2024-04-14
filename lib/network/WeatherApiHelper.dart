import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherwise/models/forecast_data.dart';
import 'package:weatherwise/models/weather_data.dart';

class WeatherApiHelper {
  final String apiKey;
  final String baseUrl = "https://api.openweathermap.org/data/2.5";

  WeatherApiHelper(this.apiKey);

  Future<WeatherData?> getCurrentWeatherData(double latitude, double longitude) async {
    const String endpoint = "/weather";
    final String url = "$baseUrl$endpoint?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      // throw Exception("Failed to load weather data");
      return null;
    }
  }

  Future<ForecastData?> getForecastData(double latitude, double longitude) async {
    const String endpoint = "/forecast";
    final String url = "$baseUrl$endpoint?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return ForecastData.fromJson(json.decode(response.body));
    } else {
      // throw Exception("Failed to load forecast data");
      return null;
    }
  }

}
