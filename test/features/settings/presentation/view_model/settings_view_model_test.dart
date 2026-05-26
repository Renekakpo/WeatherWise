import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weatherwise/core/error/app_failure.dart';
import 'package:weatherwise/core/result/result.dart';
import 'package:weatherwise/features/settings/domain/entities/app_settings.dart';
import 'package:weatherwise/features/settings/domain/entities/temperature_unit.dart';
import 'package:weatherwise/features/settings/domain/repositories/settings_repository.dart';
import 'package:weatherwise/features/settings/presentation/providers/settings_providers.dart';
import 'package:weatherwise/features/settings/presentation/view_model/settings_view_model.dart';

class _MockRepository extends Mock implements SettingsRepository {}

class _Fake extends Fake {}

void main() {
  setUpAll(() {
    registerFallbackValue(const AppSettings.defaults());
  });

  late _MockRepository repo;

  ProviderContainer makeContainer() {
    return ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(repo),
      ],
    );
  }

  setUp(() {
    repo = _MockRepository();
  });

  test('build() exposes settings loaded from repository', () async {
    when(repo.load).thenAnswer(
      (_) async => const Success(
        AppSettings(
          unit: TemperatureUnit.imperial,
          autoRefreshHours: 6,
          refreshOnTheGo: true,
        ),
      ),
    );

    final container = makeContainer();
    addTearDown(container.dispose);

    final settings = await container.read(settingsViewModelProvider.future);
    expect(settings.unit, TemperatureUnit.imperial);
    expect(settings.autoRefreshHours, 6);
    expect(settings.refreshOnTheGo, isTrue);
  });

  test('build() converts failure to AsyncError', () async {
    when(repo.load).thenAnswer((_) async => const Failure(CacheFailure()));

    final container = makeContainer();
    addTearDown(container.dispose);

    await container.read(settingsViewModelProvider.future).catchError((_) => const AppSettings.defaults());
    final state = container.read(settingsViewModelProvider);
    expect(state, isA<AsyncError>());
    expect(state.error, isA<CacheFailure>());
  });

  test('setUnit optimistically updates then confirms on success', () async {
    when(repo.load).thenAnswer(
      (_) async => const Success(AppSettings.defaults()),
    );
    when(() => repo.save(any())).thenAnswer((_) async => const Success(null));

    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(settingsViewModelProvider.future);

    await container
        .read(settingsViewModelProvider.notifier)
        .setUnit(TemperatureUnit.imperial);

    final state = container.read(settingsViewModelProvider);
    expect(state.value?.unit, TemperatureUnit.imperial);
    verify(() => repo.save(any(that: predicate<AppSettings>((s) => s.unit == TemperatureUnit.imperial)))).called(1);
  });

  test('setAutoRefreshHours rolls back state on save failure', () async {
    when(repo.load).thenAnswer(
      (_) async => const Success(AppSettings.defaults()),
    );
    when(() => repo.save(any())).thenAnswer(
      (_) async => const Failure(CacheFailure()),
    );

    final container = makeContainer();
    addTearDown(container.dispose);
    await container.read(settingsViewModelProvider.future);

    await container
        .read(settingsViewModelProvider.notifier)
        .setAutoRefreshHours(6);

    final state = container.read(settingsViewModelProvider);
    expect(state, isA<AsyncError>());
    expect(state.error, isA<CacheFailure>());
  });
}
