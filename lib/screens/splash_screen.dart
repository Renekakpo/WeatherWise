import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../helpers/notification_helper.dart';
import '../helpers/permission_helper.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  StreamSubscription<PermissionStatus>? _permissionStatusSubscription;
  bool _openedAppSettings = false;
  // Instance of notification helper class
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    // Subscribe to permission status changes
    _permissionStatusSubscription =
        PermissionHelper().permissionStatusStream.listen((status) {
          if (status == PermissionStatus.granted) {
            _navigateToNextScreen();
          } else if (status == PermissionStatus.denied || status == PermissionStatus.deniedForever) {
            _handleLocationPermissionDenied();
          }
        });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Cancel the permission status subscription
    _permissionStatusSubscription?.cancel();
    PermissionHelper().dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && _openedAppSettings) {
      _openedAppSettings = false;
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    if (!await PermissionHelper().isLocationPermissionGranted()) {
      PermissionHelper().requestLocationPermission();
    } else {
      _navigateToNextScreen();
    }
  }

  void _handleLocationPermissionDenied() async {
    if (await PermissionHelper().shouldShowLocationRequestRationale()) {
      _showExplanationDialog();
    } else { // Permission permanently denied
      _openedAppSettings = true;
      PermissionHelper().openSettings();
    }
  }

  void _showExplanationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              'Please grant location permission to continue using the app.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkPermissions();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToNextScreen() {
    // Navigate to the next screen, for example, HomeScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize notification helper object
    _notificationHelper.initialize(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
              0.1,
              0.4,
              0.6,
              0.9
            ],
                colors: [
              Colors.blueAccent,
              Colors.blue,
              Colors.lightBlue,
              Colors.lightBlueAccent
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash_cloud_img.png',
                fit: BoxFit.contain),
            const Text(
              "WeatherWise",
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text("Don't worry about the weather we all here.",
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal))
          ],
        ),
      ),
    );
  }
}
