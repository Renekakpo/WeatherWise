import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../settings/domain/entities/temperature_unit.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';
import '../mappers/weather_mapper.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl(this._dataSource);

  final WeatherRemoteDataSource _dataSource;

  @override
  Future<Result<Weather>> getCurrentWeather({
    required double latitude,
    required double longitude,
    required TemperatureUnit unit,
  }) {
    return runCatching(
      () async {
        final dto = await _dataSource.fetchCurrentWeather(
          latitude: latitude,
          longitude: longitude,
          unit: unit.apiQueryValue,
        );
        return WeatherMapper.toEntity(dto);
      },
      onError: mapExceptionToFailure,
    );
  }

  @override
  Future<Result<Forecast>> getForecast({
    required double latitude,
    required double longitude,
    required TemperatureUnit unit,
  }) {
    return runCatching(
      () async {
        final dto = await _dataSource.fetchForecast(
          latitude: latitude,
          longitude: longitude,
          unit: unit.apiQueryValue,
        );
        return ForecastMapper.toEntity(dto);
      },
      onError: mapExceptionToFailure,
    );
  }
}
