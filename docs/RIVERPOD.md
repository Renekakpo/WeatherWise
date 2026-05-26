# Riverpod patterns used in WeatherWise

This project is wired together with `flutter_riverpod ^2.5`. The patterns
below are the ones an interviewer is likely to ask about; each one
points at the canonical example in the codebase.

## 1. Provider entry shape

| Use case | Provider type | Example |
|---|---|---|
| Static dependency (HTTP client, service, repository, use case) | `Provider<T>` | `weatherRepositoryProvider` in [`weather_providers.dart`](../lib/features/weather/presentation/providers/weather_providers.dart) |
| Async one-shot read (current position, favorite location) | `FutureProvider<T>` | `favoriteLocationProvider` in [`manage_locations_view_model.dart`](../lib/features/locations/presentation/view_model/manage_locations_view_model.dart) |
| Stream from the platform | `StreamProvider<T>` | `locationServiceStatusProvider` in [`geolocator_service.dart`](../lib/core/services/geolocator_service.dart) |
| Async state with user actions | `AsyncNotifierProvider<VM, T>` | `currentWeatherViewModelProvider` in [`current_weather_view_model.dart`](../lib/features/weather/presentation/view_model/current_weather_view_model.dart) |
| Sync state | `NotifierProvider<VM, T>` | (not currently used; reserved for purely synchronous flows) |

## 2. AutoDispose by default

Every screen-bound provider is `.autoDispose` so memory is freed when
the screen leaves the tree. The exception is `settingsViewModelProvider`
which is **kept alive** because the weather, locations, and home
features all read settings -- if it auto-disposed, switching screens
would re-fetch SharedPreferences each time.

## 3. Repository / use case / view model wiring

Every feature follows the same pattern. Example, weather:

```dart
final weatherRemoteDataSourceProvider = Provider<WeatherRemoteDataSource>((ref) {
  return WeatherRemoteDataSource(
    httpClient: ref.watch(httpClientProvider),
    apiKey: ref.watch(envProvider).openWeatherApiKey,
  );
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(ref.watch(weatherRemoteDataSourceProvider));
});

final getCurrentWeatherUseCaseProvider = Provider<GetCurrentWeatherUseCase>((ref) {
  return GetCurrentWeatherUseCase(ref.watch(weatherRepositoryProvider));
});
```

The ViewModel then `ref.read`s the use case it needs:

```dart
class CurrentWeatherViewModel extends AutoDisposeAsyncNotifier<Weather> {
  @override
  Future<Weather> build() async {
    final source = await ref.watch(weatherSourceProvider.future);
    final settings = await ref.watch(settingsViewModelProvider.future);
    final result = await ref.read(getCurrentWeatherUseCaseProvider)(
      latitude: source.latitude,
      longitude: source.longitude,
      unit: settings.unit,
    );
    return result.fold(onSuccess: (w) => w, onFailure: (f) => throw f);
  }
}
```

Notes:
- `ref.watch` for things that should retrigger `build()` if they change
  (the GPS source, the user's unit preference).
- `ref.read` for one-shot calls to a use case.

## 4. Folding `Result<T>` into `AsyncValue<T>`

A repository returns `Future<Result<T>>`. The ViewModel converts the
`Failure` branch into a thrown `AppFailure`; Riverpod's
`AsyncNotifier.build()` catches it and exposes it as `AsyncError`, so
the UI's `.when` handler sees it like any other error.

For action methods (e.g. `setUnit`), the ViewModel pattern-matches
explicitly:

```dart
Future<void> setUnit(TemperatureUnit unit) async {
  final current = state.valueOrNull ?? const AppSettings.defaults();
  final previous = state;
  state = AsyncData(current.copyWith(unit: unit)); // optimistic
  final result = await ref.read(updateTemperatureUnitUseCaseProvider)(current, unit);
  result.fold(
    onSuccess: (updated) => state = AsyncData(updated),
    onFailure: (f) {
      state = previous;
      state = AsyncError(f, StackTrace.current);
    },
  );
}
```

## 5. Cross-feature invalidation

When one feature performs an action that should refresh another, it
calls `ref.invalidate`:

- Setting a favorite in `ManageLocationsScreen` invalidates
  `favoriteLocationProvider` so the HomeScreen drawer updates.
- Returning from the SettingsScreen invalidates
  `settingsViewModelProvider` (so the unit change propagates),
  `favoriteLocationProvider`, and the weather providers.

This replaces the legacy `Navigator.pop(context, true)` boolean
signaling.

## 6. ProviderScope overrides at the entry point

Async initialization happens in `bootstrap()` before `runApp`; the
resolved `SharedPreferences` instance is then injected via an override:

```dart
final boot = await bootstrap();
runApp(
  ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(boot.sharedPreferences),
    ],
    child: const WeatherWiseApp(),
  ),
);
```

`sharedPreferencesProvider` itself throws `UnimplementedError` so any
test or runtime call that forgets to override fails loudly.

## 7. ref.listen for side effects in widgets

`WeatherView` shows a notification when new weather data arrives, but
only once per `observedAt`:

```dart
ref.listen<AsyncValue<Weather>>(currentWeatherViewModelProvider, (prev, next) {
  next.whenData(_maybeShowNotification);
});
```

This is the canonical place to fire side effects: it runs outside of
`build` and doesn't trigger rebuilds.

## 8. Anti-patterns avoided

- No global singletons (`Foo()` everywhere) — every dependency comes
  through a provider.
- No `setState` in business logic — that lives in ViewModels.
- No service locator (`get_it`) alongside Riverpod — one DI mechanism.
- No `ref.read` inside `build()` of a `ConsumerWidget` for data the UI
  depends on — always `ref.watch`.

## 9. Codegen status

The project does NOT use `riverpod_generator` / `@riverpod` / build_runner.
All providers are declared manually. The cost is a few extra lines per
provider; the benefit is zero codegen friction and clearer call-sites
for code reviews. `riverpod_lint` is still active and catches the usual
anti-patterns.
