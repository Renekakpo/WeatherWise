import '../../../../core/result/result.dart';
import '../../../settings/domain/entities/temperature_unit.dart';
import '../entities/forecast.dart';
import '../entities/weather.dart';

abstract interface class WeatherRepository {
  Future<Result<Weather>> getCurrentWeather({
    required double latitude,
    required double longitude,
    required TemperatureUnit unit,
  });

  Future<Result<Forecast>> getForecast({
    required double latitude,
    required double longitude,
    required TemperatureUnit unit,
  });
}
