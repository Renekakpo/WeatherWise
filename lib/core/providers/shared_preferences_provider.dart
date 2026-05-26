import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences instance.
///
/// Initialized asynchronously during app bootstrap and injected here via a
/// [ProviderScope] override. Reading it without the override throws so
/// missing initialization surfaces immediately rather than silently.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope after '
    'SharedPreferences.getInstance() has been awaited in bootstrap().',
  );
});
