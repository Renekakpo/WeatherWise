import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/network/api_exception.dart';
import '../dtos/city_search_dto.dart';

class CitySearchRemoteDataSource {
  CitySearchRemoteDataSource({
    required http.Client httpClient,
    required String username,
  })  : _httpClient = httpClient,
        _username = username;

  final http.Client _httpClient;
  final String _username;

  Future<List<CitySearchDto>> search(String query) async {
    final uri = Uri.parse(
      'http://api.geonames.org/searchJSON'
      '?q=${Uri.encodeQueryComponent(query)}'
      '&maxRows=10&username=$_username',
    );
    final http.Response response;
    try {
      response = await _httpClient.get(uri);
    } catch (e) {
      throw NetworkException(e.toString());
    }

    if (response.statusCode != 200) {
      throw ServerException(response.statusCode, 'geonames failed');
    }

    try {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final list = (body['geonames'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();

      // Dedup by city name to match the legacy behavior.
      final seen = <String>{};
      final dtos = <CitySearchDto>[];
      for (final raw in list) {
        final dto = CitySearchDto.fromJson(raw);
        if (seen.add(dto.name)) dtos.add(dto);
      }
      return dtos;
    } catch (e) {
      throw const ParseException();
    }
  }
}
