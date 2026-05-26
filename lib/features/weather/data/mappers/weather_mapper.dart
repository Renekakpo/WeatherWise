import '../../domain/entities/forecast.dart';
import '../../domain/entities/weather.dart';
import '../dtos/forecast_dto.dart';
import '../dtos/weather_dto.dart';

abstract final class WeatherMapper {
  static Weather toEntity(WeatherDto dto) {
    return Weather(
      locationName: dto.name,
      country: dto.country,
      condition: dto.condition,
      description: dto.description,
      iconId: dto.iconId,
      temperature: dto.temperature,
      feelsLike: dto.feelsLike,
      tempMin: dto.tempMin,
      tempMax: dto.tempMax,
      pressure: dto.pressure,
      humidity: dto.humidity,
      windSpeed: dto.windSpeed,
      visibility: dto.visibility,
      sunriseTimestamp: dto.sunrise,
      sunsetTimestamp: dto.sunset,
      latitude: dto.latitude,
      longitude: dto.longitude,
      observedAt: dto.dt,
    );
  }
}

abstract final class ForecastMapper {
  static Forecast toEntity(ForecastDto dto) {
    return Forecast(
      entries: dto.entries
          .map(
            (e) => ForecastEntry(
              timestamp: e.timestamp,
              temperature: e.temperature,
              tempMin: e.tempMin,
              tempMax: e.tempMax,
              condition: e.condition,
              iconId: e.iconId,
              precipitationProbability: e.precipitationProbability,
              windSpeed: e.windSpeed,
            ),
          )
          .toList(),
    );
  }
}
