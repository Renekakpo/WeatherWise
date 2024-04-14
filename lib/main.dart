import 'package:flutter/material.dart';
import 'package:weatherwise/screens/splash_screen.dart';

import 'helpers/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AppSharedPreferences
  await AppSharedPreferences().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'OpenSans',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const SafeArea(child: SplashScreen())
        // home: const SafeArea(child: HomeScreen(title: "Vancouver, Canada"),),
        );
  }
}
