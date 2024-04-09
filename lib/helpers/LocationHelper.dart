import 'package:location/location.dart';

class LocationHelper {
  static final LocationHelper _instance = LocationHelper._internal();

  factory LocationHelper() {
    return _instance;
  }

  LocationHelper._internal();

  Location location = Location();

  Future<bool> isLocationServiceEnabled() async {
    return await location.serviceEnabled();
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      if (await isLocationServiceEnabled()) {
        return await location.getLocation();
      } else {
        // Location services are not enabled, handle accordingly
        throw Exception("Location services are not enabled");
      }
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }
}