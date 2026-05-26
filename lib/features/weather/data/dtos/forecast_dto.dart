class ForecastEntryDto {
  const ForecastEntryDto({
    required this.timestamp,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.iconId,
    required this.precipitationProbability,
    required this.windSpeed,
  });

  factory ForecastEntryDto.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final weather =
        (json['weather'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final first = weather.isNotEmpty ? weather.first : const <String, dynamic>{};

    return ForecastEntryDto(
      timestamp: int.tryParse(json['dt'].toString()) ?? 0,
      temperature: _toDouble(main['temp']),
      tempMin: _toDouble(main['temp_min']),
      tempMax: _toDouble(main['temp_max']),
      condition: (first['main'] ?? '').toString(),
      iconId: (first['icon'] ?? '').toString(),
      precipitationProbability: _toDouble(json['pop']),
      windSpeed: _toDouble(wind['speed']),
    );
  }

  final int timestamp;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String iconId;
  final double precipitationProbability;
  final double windSpeed;
}

class ForecastDto {
  const ForecastDto({required this.entries});

  factory ForecastDto.fromJson(Map<String, dynamic> json) {
    final list = (json['list'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(ForecastEntryDto.fromJson)
        .toList();
    return ForecastDto(entries: list);
  }

  final List<ForecastEntryDto> entries;
}

double _toDouble(Object? v) => double.tryParse(v?.toString() ?? '') ?? 0.0;
