class WeatherDto {
  const WeatherDto({
    required this.name,
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
    required this.sunrise,
    required this.sunset,
    required this.latitude,
    required this.longitude,
    required this.dt,
  });

  factory WeatherDto.fromJson(Map<String, dynamic> json) {
    final coord = json['coord'] as Map<String, dynamic>? ?? {};
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final sys = json['sys'] as Map<String, dynamic>? ?? {};
    final weather =
        (json['weather'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final first = weather.isNotEmpty ? weather.first : const <String, dynamic>{};

    return WeatherDto(
      name: (json['name'] ?? '').toString(),
      country: (sys['country'] ?? '').toString(),
      condition: (first['main'] ?? '').toString(),
      description: (first['description'] ?? '').toString(),
      iconId: (first['icon'] ?? '').toString(),
      temperature: _toDouble(main['temp']),
      feelsLike: _toDouble(main['feels_like']),
      tempMin: _toDouble(main['temp_min']),
      tempMax: _toDouble(main['temp_max']),
      pressure: _toInt(main['pressure']),
      humidity: _toInt(main['humidity']),
      windSpeed: _toDouble(wind['speed']),
      visibility: _toInt(json['visibility']),
      sunrise: _toInt(sys['sunrise']),
      sunset: _toInt(sys['sunset']),
      latitude: _toDouble(coord['lat']),
      longitude: _toDouble(coord['lon']),
      dt: _toInt(json['dt']),
    );
  }

  final String name;
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
  final int sunrise;
  final int sunset;
  final double latitude;
  final double longitude;
  final int dt;
}

double _toDouble(Object? v) => double.tryParse(v?.toString() ?? '') ?? 0.0;

int _toInt(Object? v) => int.tryParse(v?.toString() ?? '') ?? 0;
