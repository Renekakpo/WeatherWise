import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'helpers/permission_helper.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  final boot = await bootstrap();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(boot.sharedPreferences),
      ],
      child: const WeatherWiseApp(),
    ),
  );
}

/// Legacy entry widget retained for backward compatibility with existing
/// widget tests that build the app via `MyApp(...)`. New code should use
/// [WeatherWiseApp] directly. This shim will be removed in step 9 once
/// SplashScreen is migrated and the legacy tests are rewritten.
@Deprecated('Use WeatherWiseApp; retained for legacy tests until step 9.')
class MyApp extends StatelessWidget {
  const MyApp({super.key, this.permissionHelper});

  final PermissionHelper? permissionHelper;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: SafeArea(
        child: SplashScreen(
          permissionHelper: permissionHelper ?? PermissionHelper(),
        ),
      ),
    );
  }
}
