import 'package:flutter_test/flutter_test.dart';
import 'package:weatherwise/features/locations/data/dtos/city_search_dto.dart';

void main() {
  test('fromJson + toEntity preserves fields', () {
    final dto = CitySearchDto.fromJson({
      'name': 'Paris',
      'adminName1': 'Ile-de-France',
      'countryName': 'France',
      'lat': '48.85',
      'lng': '2.35',
    });

    expect(dto.name, 'Paris');
    expect(dto.adminName, 'Ile-de-France');
    expect(dto.countryName, 'France');
    expect(dto.latitude, closeTo(48.85, 0.01));
    expect(dto.longitude, closeTo(2.35, 0.01));

    final entity = dto.toEntity();
    expect(entity.displaySubtitle, 'Ile-de-France, France');
  });

  test('defaults to 0.0 / "" when fields are missing', () {
    final dto = CitySearchDto.fromJson({'name': 'X'});
    expect(dto.adminName, isEmpty);
    expect(dto.countryName, isEmpty);
    expect(dto.latitude, 0.0);
    expect(dto.longitude, 0.0);
  });
}
