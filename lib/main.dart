import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';
import 'core/providers/shared_preferences_provider.dart';

Future<void> main() async {
  final boot = await bootstrap();

  runApp(
    ProviderScope(
      // Riverpod 3 auto-retries failed provider builds; the app models load
      // failures as terminal AsyncError states surfaced to the user, so opt out.
      retry: (_, __) => null,
      overrides: [
        sharedPreferencesProvider.overrideWithValue(boot.sharedPreferences),
      ],
      child: const WeatherWiseApp(),
    ),
  );
}
