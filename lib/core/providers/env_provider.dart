import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppEnv {
  const AppEnv({
    required this.openWeatherApiKey,
    required this.geonamesUsername,
    required this.supportEmail,
  });

  final String openWeatherApiKey;
  final String geonamesUsername;
  final String supportEmail;
}

/// Reads environment configuration from the already-loaded dotenv map.
/// Bootstrap awaits dotenv.load() before any consumer reads this provider.
final envProvider = Provider<AppEnv>((ref) {
  return AppEnv(
    openWeatherApiKey: dotenv.env['WEATHER_WISE_API_KEY'] ?? '',
    geonamesUsername: dotenv.env['GEONAMES_USERNAME'] ?? 'anukus',
    supportEmail: dotenv.env['SUPPORT_EMAIL'] ?? '',
  );
});
