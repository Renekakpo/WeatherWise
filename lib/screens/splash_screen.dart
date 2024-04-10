import 'package:flutter/material.dart';

import '../helpers/PermissionHelper.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    bool permissionGranted =
        await PermissionHelper().requestLocationPermission();
    if (!permissionGranted) {
      // Handle the case when permission is not granted
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Required'),
            content: Text(
                'Please grant location permission to continue using the app.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Permission granted, proceed to the next screen
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    // Navigate to the next screen, for example, HomeScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => const HomeScreen(title: "Vancouver, Canada")),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            const Text("Don't worry about the weather we all here",
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
