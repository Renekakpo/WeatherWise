import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weatherwise/core/services/permission_service.dart';
import 'package:weatherwise/features/splash/presentation/view_model/splash_view_model.dart';

class _MockService extends Mock implements PermissionService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockService service;

  ProviderContainer makeContainer() => ProviderContainer(
        overrides: [permissionServiceProvider.overrideWithValue(service)],
      );

  setUp(() {
    service = _MockService();
    when(service.openSettings).thenAnswer((_) async {});
  });

  test('already-granted permission emits SplashPermissionGranted', () async {
    when(service.isLocationPermissionGranted).thenAnswer((_) async => true);

    final container = makeContainer();
    addTearDown(container.dispose);

    final initial = container.read(splashViewModelProvider);
    expect(initial, isA<SplashChecking>());

    await container.read(splashViewModelProvider.notifier).check();

    expect(container.read(splashViewModelProvider), isA<SplashPermissionGranted>());
  });

  test('newly-granted permission emits SplashPermissionGranted', () async {
    when(service.isLocationPermissionGranted).thenAnswer((_) async => false);
    when(service.requestLocationPermission).thenAnswer((_) async => true);

    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(splashViewModelProvider.notifier).check();

    expect(container.read(splashViewModelProvider), isA<SplashPermissionGranted>());
  });

  test('denied permission emits SplashPermissionDenied', () async {
    when(service.isLocationPermissionGranted).thenAnswer((_) async => false);
    when(service.requestLocationPermission).thenAnswer((_) async => false);
    when(service.isLocationPermanentlyDenied).thenAnswer((_) async => false);

    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(splashViewModelProvider.notifier).check();

    expect(container.read(splashViewModelProvider), isA<SplashPermissionDenied>());
  });

  test('permanently denied opens settings and emits permanently-denied state',
      () async {
    when(service.isLocationPermissionGranted).thenAnswer((_) async => false);
    when(service.requestLocationPermission).thenAnswer((_) async => false);
    when(service.isLocationPermanentlyDenied).thenAnswer((_) async => true);

    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(splashViewModelProvider.notifier).check();

    verify(service.openSettings).called(greaterThanOrEqualTo(1));
    expect(
      container.read(splashViewModelProvider),
      isA<SplashPermissionPermanentlyDenied>(),
    );
  });
}
