import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/shared_preferences_helper.dart';

class BootstrapResult {
  const BootstrapResult({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
}

Future<BootstrapResult> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  AppSharedPreferences(prefs: prefs);

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    if (kDebugMode) {
      debugPrint('bootstrap: env load failed: $e');
    }
  }

  return BootstrapResult(sharedPreferences: prefs);
}
