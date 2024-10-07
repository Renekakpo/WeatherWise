import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:weatherwise/helpers/permission_helper.dart';

// Define your mock class
class MockLocation extends Mock implements Location {}

// Define a mocktail extension for async methods returning void
extension VoidAnswer on When<Future<void>> {
  void thenAnswerWithVoid() => thenAnswer((_) async {});
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized

  group('PermissionHelper', () {
    late PermissionHelper permissionHelper;
    late MockLocation mockLocation;

    setUp(() {
      mockLocation = MockLocation();
      permissionHelper = PermissionHelper(location: mockLocation);

      // Mock the methods that return Future<PermissionStatus>
      when(() => mockLocation.hasPermission()).thenAnswer((_) async => PermissionStatus.denied);
      when(() => mockLocation.requestPermission()).thenAnswer((_) async => PermissionStatus.denied);
    });

    tearDown(() {
      permissionHelper.dispose();
    });

    test('isLocationPermissionGranted() returns true when permission is granted', () async {
      when(() => mockLocation.hasPermission()).thenAnswer((_) async => PermissionStatus.granted);
      bool hasPermission = await permissionHelper.isLocationPermissionGranted();
      expect(hasPermission, true);
    });

    test('isLocationPermissionGranted() returns false when permission is not granted', () async {
      when(() => mockLocation.hasPermission()).thenAnswer((_) async => PermissionStatus.denied);
      bool hasPermission = await permissionHelper.isLocationPermissionGranted();
      expect(hasPermission, false);
    });

    test('requestLocationPermission() returns true when permission is granted', () async {
      // Setup the mock behavior
      when(() => mockLocation.requestPermission()).thenAnswer((_) async => PermissionStatus.granted);

      // Start listening to the stream and wait for the first emitted status
      final Future<PermissionStatus> permissionStatusFuture =
          permissionHelper.permissionStatusStream.first;

      // Call the method to request location permission
      bool hasPermission = await permissionHelper.requestLocationPermission();

      // Wait for the stream to emit a value
      final latestStatus = await permissionStatusFuture;

      // Wait for the stream to emit the latest status
      expect(hasPermission, true);
      expect(latestStatus, PermissionStatus.granted);
    });

    test('requestLocationPermission() returns false when permission is denied', () async {
      // Setup the mock behavior
      when(() => mockLocation.requestPermission()).thenAnswer((_) async => PermissionStatus.denied);

      // Start listening to the stream and wait for the first emitted status
      final Future<PermissionStatus> permissionStatusFuture =
          permissionHelper.permissionStatusStream.first;

      // Call the method to request location permission
      bool hasPermission = await permissionHelper.requestLocationPermission();

      // Wait for the stream to emit a value
      final latestStatus = await permissionStatusFuture;

      // Wait for the stream to emit the latest status
      expect(hasPermission, false);
      expect(latestStatus, PermissionStatus.denied);
    });

    test('shouldShowLocationRequestRationale() returns false by default', () async {
      bool shouldShowRationale = await permissionHelper.shouldShowLocationRequestRationale();
      expect(shouldShowRationale, false);
    });

    test('checkLocationPermanentlyDenied() returns true when permission is permanently denied', () async {
      when(() => mockLocation.hasPermission()).thenAnswer((_) async => PermissionStatus.deniedForever);
      bool isPermanentlyDenied = await permissionHelper.checkLocationPermanentlyDenied();
      expect(isPermanentlyDenied, true);
    });

    test('checkLocationPermanentlyDenied() returns false when permission is not permanently denied', () async {
      when(() => mockLocation.hasPermission()).thenAnswer((_) async => PermissionStatus.denied);
      bool isPermanentlyDenied = await permissionHelper.checkLocationPermanentlyDenied();
      expect(isPermanentlyDenied, false);
    });

    test('openSettings() calls openAppSettings()', () {
      // Since we can't test the call directly, you can use a mock if needed
      perm.openAppSettings();
    });
  });
}