import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static final LocationHelper _instance = LocationHelper._internal();

  factory LocationHelper() {
    return _instance;
  }

  LocationHelper._internal();

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}