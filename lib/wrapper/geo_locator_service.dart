import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }
}