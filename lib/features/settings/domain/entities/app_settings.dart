import 'temperature_unit.dart';

/// User-configurable application preferences. Immutable value object.
class AppSettings {
  const AppSettings({
    required this.unit,
    required this.autoRefreshHours,
    required this.refreshOnTheGo,
  });

  /// Default values applied when no preference has ever been stored.
  const AppSettings.defaults()
      : unit = TemperatureUnit.metric,
        autoRefreshHours = 0,
        refreshOnTheGo = false;

  final TemperatureUnit unit;

  /// Auto-refresh interval in hours. 0 means disabled.
  final int autoRefreshHours;

  /// Whether pull-to-refresh on the weather screen is enabled.
  final bool refreshOnTheGo;

  AppSettings copyWith({
    TemperatureUnit? unit,
    int? autoRefreshHours,
    bool? refreshOnTheGo,
  }) {
    return AppSettings(
      unit: unit ?? this.unit,
      autoRefreshHours: autoRefreshHours ?? this.autoRefreshHours,
      refreshOnTheGo: refreshOnTheGo ?? this.refreshOnTheGo,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          other.unit == unit &&
          other.autoRefreshHours == autoRefreshHours &&
          other.refreshOnTheGo == refreshOnTheGo;

  @override
  int get hashCode => Object.hash(unit, autoRefreshHours, refreshOnTheGo);

  @override
  String toString() =>
      'AppSettings(unit: $unit, autoRefreshHours: $autoRefreshHours, '
      'refreshOnTheGo: $refreshOnTheGo)';
}
