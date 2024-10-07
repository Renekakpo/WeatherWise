import 'dart:async';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class PermissionHelper {
  static PermissionHelper _instance = PermissionHelper._internal(Location());

  factory PermissionHelper({Location? location}) {
    if (location != null) {
      _instance = PermissionHelper._internal(location); // Update the instance's _location
    }
    return _instance;
  }

  PermissionHelper._internal(this._location); // Constructor with Location

  // Stream controller for permission status changes
  final StreamController<PermissionStatus> _permissionStatusController =
  StreamController<PermissionStatus>.broadcast();

  Stream<PermissionStatus> get permissionStatusStream =>
      _permissionStatusController.stream;

   Location _location; // Initialize _location here

  Future<bool> isLocationPermissionGranted() async {
    final PermissionStatus status = await _location.hasPermission();
    return status == PermissionStatus.granted;
  }

  Future<bool> requestLocationPermission() async {
    final bool hasPermission = await isLocationPermissionGranted();
    if (hasPermission) {
      _permissionStatusController.add(PermissionStatus.granted);
      return true;
    }

    final PermissionStatus status = await _location.requestPermission();
    _permissionStatusController.add(status);
    return status == PermissionStatus.granted;
  }

  Future<bool> shouldShowLocationRequestRationale() async {
    // The location library does not provide a direct method to check if the rationale should be shown.
    // You might want to handle this based on your app's logic.
    return false;
  }

  Future<bool> checkLocationPermanentlyDenied() async {
    final PermissionStatus status = await _location.hasPermission();
    return status == PermissionStatus.deniedForever;
  }

  void openSettings() {
    perm.openAppSettings();
  }

  // Dispose the stream controller when it's no longer needed
  void dispose() {
    _permissionStatusController.close();
  }
}