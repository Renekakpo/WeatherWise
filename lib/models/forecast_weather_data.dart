class ForecastWeatherData {
  double hour;
  double temperature;
  String weatherType;
  double raindropProb;

  ForecastWeatherData(
      {required this.hour,
      required this.weatherType,
      required this.temperature,
      required this.raindropProb});

  @override
  String toString() {
    return 'Hour: $hour, Temperature: $temperature, Weather Type: $weatherType, Raindrop Probability: $raindropProb%';
  }
}
