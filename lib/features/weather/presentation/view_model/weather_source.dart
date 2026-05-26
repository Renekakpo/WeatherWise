import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/geolocator_service.dart';
import '../../../locations/presentation/view_model/manage_locations_view_model.dart';

/// Coordinates of the location whose weather should be displayed in the
/// HomeScreen, along with a label for the AppBar and a flag that tells the
/// UI whether the source is the live GPS.
class WeatherSource {
  const WeatherSource({
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.fromDeviceLocation,
  });

  final double latitude;
  final double longitude;
  final String label;
  final bool fromDeviceLocation;
}

/// Resolves the active source: prefer the device GPS when the location
/// service is on, otherwise fall back to the user's favorite saved location.
final weatherSourceProvider = FutureProvider<WeatherSource?>((ref) async {
  final serviceEnabled = await ref
      .watch(geolocatorServiceProvider)
      .isLocationServiceEnabled();

  if (serviceEnabled) {
    try {
      final position = await ref.watch(currentPositionProvider.future);
      return WeatherSource(
        latitude: position.latitude,
        longitude: position.longitude,
        label: '',
        fromDeviceLocation: true,
      );
    } catch (_) {
      // fall through to favorite
    }
  }

  final favorite = await ref.watch(favoriteLocationProvider.future);
  if (favorite == null) return null;
  return WeatherSource(
    latitude: favorite.latitude,
    longitude: favorite.longitude,
    label: favorite.name,
    fromDeviceLocation: false,
  );
});
