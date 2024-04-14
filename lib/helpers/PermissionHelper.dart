import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static final PermissionHelper _instance = PermissionHelper._internal();

  factory PermissionHelper() {
    return _instance;
  }

  PermissionHelper._internal();

  // Stream controller for permission status changes
  final StreamController<PermissionStatus> _permissionStatusController =
  StreamController<PermissionStatus>.broadcast();

  Stream<PermissionStatus> get permissionStatusStream =>
      _permissionStatusController.stream;

  Future<bool> isLocationPermissionGranted() async {
    final PermissionStatus status = await Permission.location.status;
    return status == PermissionStatus.granted;
  }

  Future<bool> requestLocationPermission() async {
    if (await isLocationPermissionGranted()) { // If permission is already granted
      _permissionStatusController.add(PermissionStatus.granted);
      return true;
    }

    final PermissionStatus status = await Permission.location.request(); // Request for permission
    _permissionStatusController.add(status); // Add status to stream
    return status == PermissionStatus.granted;
  }

  Future<bool> shouldShowLocationRequestRationale() async {
    const permission = Permission.location;
    return permission.shouldShowRequestRationale;
  }

  Future<bool> checkLocationPermanentlyDenied() async {
    return await Permission.location.status.isPermanentlyDenied;
  }

  void openSettings() {
    openAppSettings();
  }

  // Dispose the stream controller when it's no longer needed
  void dispose() {
    _permissionStatusController.close();
  }
}