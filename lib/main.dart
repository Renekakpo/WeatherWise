import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'core/providers/shared_preferences_provider.dart';

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
