/// Temperature / wind unit selection. Persisted as a bool in
/// SharedPreferences (legacy schema): false = metric, true = imperial.
enum TemperatureUnit {
  metric,
  imperial;

  /// Value sent to OpenWeather's `units` query parameter.
  String get apiQueryValue => switch (this) {
        TemperatureUnit.metric => 'metric',
        TemperatureUnit.imperial => 'imperial',
      };

  /// Symbol displayed in the UI for temperatures.
  String get temperatureSymbol => switch (this) {
        TemperatureUnit.metric => 'ºC',
        TemperatureUnit.imperial => 'ºF',
      };

  bool get isImperial => this == TemperatureUnit.imperial;

  factory TemperatureUnit.fromIsImperial(bool isImperial) =>
      isImperial ? TemperatureUnit.imperial : TemperatureUnit.metric;
}
