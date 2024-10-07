import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherwise/helpers/permission_helper.dart';
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

  runApp(MyApp(permissionHelper: PermissionHelper(),));
}

class MyApp extends StatelessWidget {
  final PermissionHelper? permissionHelper;

  const MyApp({super.key, this.permissionHelper});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'OpenSans',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: SafeArea(child: SplashScreen(permissionHelper: permissionHelper ?? PermissionHelper(),)));
  }
}
