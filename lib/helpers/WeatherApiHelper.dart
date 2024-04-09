import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiHelper {
  final String apiKey;
  final String baseUrl = "https://api.openweathermap.org/data/2.5";

  WeatherApiHelper(this.apiKey);

  Future<Map<String, dynamic>> getCurrentWeather(double latitude, double longitude) async {
    const String endpoint = "/weather";
    final String url = "$baseUrl$endpoint?lat=$latitude&lon=$longitude&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }

// Add more methods for fetching forecast, additional weather details, etc.
}
