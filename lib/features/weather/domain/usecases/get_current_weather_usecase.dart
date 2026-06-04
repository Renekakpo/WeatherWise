import '../../../../core/result/result.dart';
import '../../../settings/domain/entities/temperature_unit.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetCurrentWeatherUseCase {
  const GetCurrentWeatherUseCase(this._repository);
  final WeatherRepository _repository;

  Future<Result<Weather>> call({
    required double latitude,
    required double longitude,
    required TemperatureUnit unit,
  }) {
    return _repository.getCurrentWeather(
      latitude: latitude,
      longitude: longitude,
      unit: unit,
    );
  }
}
