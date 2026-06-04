import '../../../../core/result/result.dart';
import '../../../settings/domain/entities/temperature_unit.dart';
import '../entities/forecast.dart';
import '../repositories/weather_repository.dart';

class GetForecastUseCase {
  const GetForecastUseCase(this._repository);
  final WeatherRepository _repository;

  Future<Result<Forecast>> call({
    required double latitude,
    required double longitude,
    required TemperatureUnit unit,
  }) {
    return _repository.getForecast(
      latitude: latitude,
      longitude: longitude,
      unit: unit,
    );
  }
}
