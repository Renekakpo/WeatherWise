import '../../domain/entities/city_suggestion.dart';

class CitySearchDto {
  const CitySearchDto({
    required this.name,
    required this.adminName,
    required this.countryName,
    required this.latitude,
    required this.longitude,
  });

  factory CitySearchDto.fromJson(Map<String, dynamic> json) {
    return CitySearchDto(
      name: (json['name'] ?? '').toString(),
      adminName: (json['adminName1'] ?? '').toString(),
      countryName: (json['countryName'] ?? '').toString(),
      latitude: double.tryParse(json['lat'].toString()) ?? 0.0,
      longitude: double.tryParse(json['lng'].toString()) ?? 0.0,
    );
  }

  final String name;
  final String adminName;
  final String countryName;
  final double latitude;
  final double longitude;

  CitySuggestion toEntity() => CitySuggestion(
        name: name,
        adminName: adminName,
        countryName: countryName,
        latitude: latitude,
        longitude: longitude,
      );
}
