/// A weather location persisted in the local database. Mirrors the legacy
/// ManageLocation schema so the existing sqlite store still works without
/// any migration.
class SavedLocation {
  const SavedLocation({
    this.id,
    required this.name,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.isFavorite,
    required this.useDeviceLocation,
    required this.weatherCondition,
    required this.weatherIconId,
    required this.currentTemperature,
    required this.minTemperature,
    required this.maxTemperature,
  });

  final int? id;
  final String name;
  final String region;
  final double latitude;
  final double longitude;
  final bool isFavorite;
  final bool useDeviceLocation;
  final String weatherCondition;
  final String weatherIconId;
  final double currentTemperature;
  final double minTemperature;
  final double maxTemperature;

  SavedLocation copyWith({
    int? id,
    bool? isFavorite,
  }) {
    return SavedLocation(
      id: id ?? this.id,
      name: name,
      region: region,
      latitude: latitude,
      longitude: longitude,
      isFavorite: isFavorite ?? this.isFavorite,
      useDeviceLocation: useDeviceLocation,
      weatherCondition: weatherCondition,
      weatherIconId: weatherIconId,
      currentTemperature: currentTemperature,
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedLocation && other.id == id && id != null;

  @override
  int get hashCode => id?.hashCode ?? identityHashCode(this);
}
