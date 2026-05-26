import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class PermissionService {
  PermissionService({Location? location}) : _location = location ?? Location();

  final Location _location;
  final StreamController<PermissionStatus> _statusController =
      StreamController<PermissionStatus>.broadcast();

  Stream<PermissionStatus> get permissionStatusStream => _statusController.stream;

  Future<bool> isLocationPermissionGranted() async {
    final status = await _location.hasPermission();
    return status == PermissionStatus.granted;
  }

  Future<bool> requestLocationPermission() async {
    if (await isLocationPermissionGranted()) {
      _statusController.add(PermissionStatus.granted);
      return true;
    }
    final status = await _location.requestPermission();
    _statusController.add(status);
    return status == PermissionStatus.granted;
  }

  Future<bool> isLocationPermanentlyDenied() async {
    final status = await _location.hasPermission();
    return status == PermissionStatus.deniedForever;
  }

  /// The Location plugin does not expose a rationale check directly. Returns
  /// false; callers may show a dialog based on their own UX heuristic.
  Future<bool> shouldShowLocationRequestRationale() async => false;

  Future<void> openSettings() => perm.openAppSettings();

  void dispose() {
    _statusController.close();
  }
}

final permissionServiceProvider = Provider<PermissionService>((ref) {
  final service = PermissionService();
  ref.onDispose(service.dispose);
  return service;
});
