import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherwise/screens/splash_screen.dart';

import 'helpers/support_center_helper.dart';
import 'helpers/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AppSharedPreferences
  await AppSharedPreferences().init();

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
    // Initialize SupportCenterHelper
    SupportCenterHelper().initialize();
  } catch (e) {
    if (kDebugMode) {
      print('Error loading .env file: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'OpenSans',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const SafeArea(child: SplashScreen()));
  }
}
