class ManageLocation {
  final int? id;
  String name;
  String region;
  bool isFavorite;
  bool useDeviceLocation;
  String weatherCondition;
  double currentTemperature;
  double minTemperature;
  double maxTemperature;

  ManageLocation({
    this.id,
    required this.name,
    required this.region,
    required this.isFavorite,
    required this.useDeviceLocation,
    required this.weatherCondition,
    required this.currentTemperature,
    required this.minTemperature,
    required this.maxTemperature,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'isFavorite': isFavorite ? 1 : 0,
      'useDeviceLocation': useDeviceLocation ? 1 : 0,
      'weatherCondition': weatherCondition,
      'currentTemperature': currentTemperature,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
    };
  }
}