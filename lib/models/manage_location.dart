class ManageLocation {
  final int? id;
  String name;
  String region;
  double longitude;
  double latitude;
  bool isFavorite;
  bool useDeviceLocation;
  String weatherCondition;
  String weatherIconId;
  double currentTemperature;
  double minTemperature;
  double maxTemperature;

  ManageLocation({
    this.id,
    required this.name,
    required this.region,
    required this.longitude,
    required this.latitude,
    required this.isFavorite,
    required this.useDeviceLocation,
    required this.weatherCondition,
    required this.weatherIconId,
    required this.currentTemperature,
    required this.minTemperature,
    required this.maxTemperature,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'latitude': latitude,
      'longitude': longitude,
      'isFavorite': isFavorite ? 1 : 0,
      'useDeviceLocation': useDeviceLocation ? 1 : 0,
      'weatherCondition': weatherCondition,
      'weatherIconId': weatherIconId,
      'currentTemperature': currentTemperature,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
    };
  }

  factory ManageLocation.fromMap(Map<String, dynamic> map) {
    return ManageLocation(
      id: map['id'],
      name: map['name'],
      region: map['region'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      isFavorite: map['isFavorite'] == 1,
      useDeviceLocation: map['useDeviceLocation'] == 1,
      weatherCondition: map['weatherCondition'],
      weatherIconId: map['weatherIconId'],
      currentTemperature: map['currentTemperature'],
      minTemperature: map['minTemperature'],
      maxTemperature: map['maxTemperature'],
    );
  }
}
