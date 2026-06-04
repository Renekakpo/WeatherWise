import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  const GeolocatorService();

  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Stream<ServiceStatus> get serviceStatusStream {
    return Geolocator.getServiceStatusStream();
  }
}

final geolocatorServiceProvider = Provider<GeolocatorService>((_) {
  return const GeolocatorService();
});

/// Stream of GPS service on/off transitions. Surfaces the platform stream
/// as an AsyncValue UI consumers can `.when` over.
final locationServiceStatusProvider = StreamProvider<ServiceStatus>((ref) {
  return ref.watch(geolocatorServiceProvider).serviceStatusStream;
});

/// Cached current position. Reads once per scope; consumers can invalidate
/// it to force a refresh.
final currentPositionProvider = FutureProvider<Position>((ref) {
  return ref.watch(geolocatorServiceProvider).getCurrentPosition();
});
