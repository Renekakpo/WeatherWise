import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BootstrapResult {
  const BootstrapResult({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
}

/// Performs every asynchronous startup step the app needs before runApp.
/// The resolved SharedPreferences instance is handed back so the entry
/// point can seed sharedPreferencesProvider via a ProviderScope override.
Future<BootstrapResult> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    if (kDebugMode) {
      debugPrint('bootstrap: env load failed: $e');
    }
  }

  return BootstrapResult(sharedPreferences: prefs);
}
