import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/permission_helper.dart';
import '../screens/splash_screen.dart';

class WeatherWiseApp extends ConsumerWidget {
  const WeatherWiseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: SplashScreen(permissionHelper: PermissionHelper()),
      ),
    );
  }
}
