class ManageLocation {
  String name;
  String region;
  bool isFavorite;
  bool useDeviceLocation;
  String weatherCondition;
  double currentTemperature;
  double minTemperature;
  double maxTemperature;

  ManageLocation({
    required this.name,
    required this.region,
    required this.isFavorite,
    required this.useDeviceLocation,
    required this.weatherCondition,
    required this.currentTemperature,
    required this.minTemperature,
    required this.maxTemperature,
  });
}