import 'package:flutter_test/flutter_test.dart';
import 'package:weatherwise/features/weather/data/dtos/forecast_dto.dart';
import 'package:weatherwise/features/weather/data/dtos/weather_dto.dart';
import 'package:weatherwise/features/weather/data/mappers/weather_mapper.dart';

void main() {
  group('WeatherDto.fromJson', () {
    test('parses a typical OpenWeather response', () {
      final dto = WeatherDto.fromJson({
        'coord': {'lon': 2.35, 'lat': 48.85},
        'weather': [
          {'main': 'Clear', 'description': 'clear sky', 'icon': '01d'}
        ],
        'main': {
          'temp': 20.0,
          'feels_like': 19.5,
          'temp_min': 18.0,
          'temp_max': 22.0,
          'pressure': 1015,
          'humidity': 60,
        },
        'wind': {'speed': 3.5},
        'visibility': 10000,
        'sys': {'country': 'FR', 'sunrise': 1000, 'sunset': 2000},
        'name': 'Paris',
        'dt': 5000,
      });

      expect(dto.name, 'Paris');
      expect(dto.country, 'FR');
      expect(dto.condition, 'Clear');
      expect(dto.iconId, '01d');
      expect(dto.temperature, 20.0);
      expect(dto.pressure, 1015);
      expect(dto.latitude, closeTo(48.85, 0.001));
      expect(dto.dt, 5000);
    });

    test('handles missing fields with safe defaults', () {
      final dto = WeatherDto.fromJson({'name': 'X'});
      expect(dto.country, isEmpty);
      expect(dto.condition, isEmpty);
      expect(dto.temperature, 0.0);
      expect(dto.pressure, 0);
    });
  });

  group('WeatherMapper.toEntity', () {
    test('maps DTO fields to entity 1:1', () {
      final dto = WeatherDto.fromJson({
        'name': 'Lyon',
        'main': {'temp': 15.0, 'feels_like': 14.0, 'temp_min': 12.0, 'temp_max': 18.0, 'pressure': 1010, 'humidity': 55},
        'wind': {'speed': 2.0},
        'visibility': 8000,
        'sys': {'country': 'FR', 'sunrise': 1, 'sunset': 2},
        'weather': [{'main': 'Rain', 'description': 'light rain', 'icon': '10d'}],
        'coord': {'lat': 45.7, 'lon': 4.8},
        'dt': 99,
      });
      final entity = WeatherMapper.toEntity(dto);
      expect(entity.locationName, 'Lyon');
      expect(entity.iconUrl, 'https://openweathermap.org/img/wn/10d@2x.png');
      expect(entity.observedAt, 99);
    });
  });

  group('ForecastDto + ForecastMapper', () {
    test('parses list and maps to entries', () {
      final dto = ForecastDto.fromJson({
        'list': [
          {
            'dt': 1,
            'main': {'temp': 10.0, 'temp_min': 9.0, 'temp_max': 11.0},
            'wind': {'speed': 1.0},
            'weather': [{'main': 'Clear', 'icon': '01d'}],
            'pop': 0.1,
          },
          {
            'dt': 2,
            'main': {'temp': 12.0, 'temp_min': 11.0, 'temp_max': 13.0},
            'wind': {'speed': 1.5},
            'weather': [{'main': 'Clouds', 'icon': '02d'}],
            'pop': 0.3,
          },
        ],
      });
      final forecast = ForecastMapper.toEntity(dto);
      expect(forecast.entries, hasLength(2));
      expect(forecast.entries.first.timestamp, 1);
      expect(forecast.entries.last.condition, 'Clouds');
    });
  });
}
