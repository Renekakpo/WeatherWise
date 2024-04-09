class ForecastData {
  String day;
  double minTemp;
  double maxTemp;
  String weatherTypeForMaxTemp;
  String weatherTypeForMinTemp;
  double raindropProb; // Raindrop probability in percentage

  ForecastData({
    required this.day,
    required this.minTemp,
    required this.maxTemp,
    required this.weatherTypeForMinTemp,
    required this.weatherTypeForMaxTemp,
    required this.raindropProb,
  });

  @override
  String toString() {
    return 'Day: $day, Raindrop: $raindropProb%, Weather: $weatherTypeForMinTemp - $weatherTypeForMaxTemp';
  }
}
