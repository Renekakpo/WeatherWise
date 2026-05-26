import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../core/services/notification_service.dart';
import '../../weather/presentation/home_screen.dart';
import 'view_model/splash_view_model.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _notificationInitialized = false;

  @override
  Widget build(BuildContext context) {
    // Initialize notifications once we have a buildContext (the legacy code
    // expected this to happen during splash).
    if (!_notificationInitialized) {
      _notificationInitialized = true;
      ref.read(notificationServiceProvider).initialize();
    }

    ref.listen<SplashState>(splashViewModelProvider, (previous, next) {
      switch (next) {
        case SplashPermissionGranted():
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        case SplashPermissionDenied():
          _showExplanationDialog();
        case SplashChecking():
        case SplashPermissionPermanentlyDenied():
          break;
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.4, 0.6, 0.9],
            colors: [
              Colors.blueAccent,
              Colors.blue,
              Colors.lightBlue,
              Colors.lightBlueAccent,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/icons/clouds_animation.json',
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            const Text(
              'WeatherWise',
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Don't worry about the weather we all here.",
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExplanationDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
            'Please grant location permission to continue using the app.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ref.read(splashViewModelProvider.notifier).check();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
