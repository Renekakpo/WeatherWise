import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static final PermissionHelper _instance = PermissionHelper._internal();

  factory PermissionHelper() {
    return _instance;
  }

  PermissionHelper._internal();

  Future<bool> isLocationPermissionGranted() async {
    final PermissionStatus status = await Permission.location.status;
    return status == PermissionStatus.granted;
  }

  Future<bool> requestLocationPermission() async {
    if (await isLocationPermissionGranted()) {
      return true; // Permission is already granted
    }

    final PermissionStatus status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }
}