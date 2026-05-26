import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/network/api_exception.dart';
import '../dtos/forecast_dto.dart';
import '../dtos/weather_dto.dart';

class WeatherRemoteDataSource {
  WeatherRemoteDataSource({
    required http.Client httpClient,
    required String apiKey,
  })  : _httpClient = httpClient,
        _apiKey = apiKey;

  static const _baseUrl = 'https://api.openweathermap.org/data/2.5';

  final http.Client _httpClient;
  final String _apiKey;

  Future<WeatherDto> fetchCurrentWeather({
    required double latitude,
    required double longitude,
    required String unit,
  }) async {
    final body = await _get('/weather', latitude, longitude, unit);
    try {
      return WeatherDto.fromJson(body);
    } catch (_) {
      throw const ParseException();
    }
  }

  Future<ForecastDto> fetchForecast({
    required double latitude,
    required double longitude,
    required String unit,
  }) async {
    final body = await _get('/forecast', latitude, longitude, unit);
    try {
      return ForecastDto.fromJson(body);
    } catch (_) {
      throw const ParseException();
    }
  }

  Future<Map<String, dynamic>> _get(
    String path,
    double lat,
    double lon,
    String unit,
  ) async {
    if (_apiKey.isEmpty) {
      throw const ServerException(401, 'API key not configured');
    }
    final uri = Uri.parse(
      '$_baseUrl$path?lat=$lat&lon=$lon&appid=$_apiKey&units=$unit',
    );
    final http.Response response;
    try {
      response = await _httpClient.get(uri);
    } catch (e) {
      throw NetworkException(e.toString());
    }
    if (response.statusCode != 200) {
      throw ServerException(response.statusCode, response.reasonPhrase ?? '');
    }
    try {
      return json.decode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw const ParseException();
    }
  }
}
