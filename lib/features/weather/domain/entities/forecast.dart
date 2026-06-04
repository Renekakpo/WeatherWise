class ForecastEntry {
  const ForecastEntry({
    required this.timestamp,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.iconId,
    required this.precipitationProbability,
    required this.windSpeed,
  });

  final int timestamp;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String iconId;
  final double precipitationProbability;
  final double windSpeed;

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconId@2x.png';
}

class Forecast {
  const Forecast({required this.entries});

  final List<ForecastEntry> entries;
}
