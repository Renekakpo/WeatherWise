/// Snapshot of the weather at a single point in time for a single location.
class Weather {
  const Weather({
    required this.locationName,
    required this.country,
    required this.condition,
    required this.description,
    required this.iconId,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
    required this.sunriseTimestamp,
    required this.sunsetTimestamp,
    required this.latitude,
    required this.longitude,
    required this.observedAt,
  });

  final String locationName;
  final String country;
  final String condition;
  final String description;
  final String iconId;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int visibility;
  final int sunriseTimestamp;
  final int sunsetTimestamp;
  final double latitude;
  final double longitude;

  /// Unix timestamp (seconds) of the observation, from the API `dt` field.
  /// Used by the notification VM as an idempotency key.
  final int observedAt;

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconId@2x.png';
}
