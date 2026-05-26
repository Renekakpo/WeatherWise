# Testing

The project uses `flutter_test` + `mocktail` exclusively (mockito and
codegen mocks have been removed).

## Folder layout

`test/` mirrors `lib/`:

```
test/
├── core/
│   ├── error/
│   ├── result/
│   └── utils/
├── features/
│   ├── locations/{data,presentation/view_model}/
│   ├── settings/{data,presentation/view_model}/
│   ├── splash/presentation/view_model/
│   ├── support/{data,presentation/view_model}/
│   └── weather/{data,domain/usecases}/
└── helpers/
    └── pump_app.dart      # widget-test ProviderScope + MaterialApp helper
```

## Mock setup

```dart
class _MockSettingsRepository extends Mock implements SettingsRepository {}

class _FakeSettings extends Fake implements AppSettings {}

setUpAll(() {
  registerFallbackValue(const AppSettings.defaults());
});
```

- One mock class per dependency, declared at the top of the file.
- `Fake` classes only for types that mocktail's `any()` needs as
  fallback (e.g. complex value objects passed to mocks).

## Unit-testing a repository

```dart
test('save writes all keys and returns Success', () async {
  when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);
  when(() => prefs.setInt(any(), any())).thenAnswer((_) async => true);

  final result = await repository.save(const AppSettings(
    unit: TemperatureUnit.imperial,
    autoRefreshHours: 12,
    refreshOnTheGo: true,
  ));

  expect(result.isSuccess, isTrue);
  verify(() => prefs.setBool('weather_unit', true)).called(1);
});
```

## Unit-testing a ViewModel with ProviderContainer

```dart
ProviderContainer makeContainer() {
  return ProviderContainer(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

test('build exposes settings loaded from repository', () async {
  when(repo.load).thenAnswer((_) async => const Success(AppSettings.defaults()));

  final container = makeContainer();
  addTearDown(container.dispose);

  final settings = await container.read(settingsViewModelProvider.future);
  expect(settings.unit, TemperatureUnit.metric);
});
```

Key points:
- `addTearDown(container.dispose)` -- always; otherwise providers leak.
- Override the providers the ViewModel reads, not the ViewModel itself.

## Sqflite testing with in-memory database

```dart
setUpAll(() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
});

setUp(() async {
  db = await openDatabase(
    inMemoryDatabasePath,
    version: 1,
    onCreate: (db, _) => db.execute('CREATE TABLE locations(...)'),
  );
  source = LocationsLocalDataSource(Future.value(db));
});

tearDown(() async {
  await db.close();
});
```

See [`locations_local_data_source_test.dart`](../test/features/locations/data/locations_local_data_source_test.dart).

## Widget tests with pumpApp

```dart
import '../../../helpers/pump_app.dart';

testWidgets('renders the unit switch', (tester) async {
  await pumpApp(
    tester,
    child: const SettingsScreen(),
    overrides: [
      settingsRepositoryProvider.overrideWithValue(MockRepo()),
    ],
  );
  expect(find.byKey(const Key('weather_units_label')), findsOneWidget);
});
```

`pumpApp` mounts a `ProviderScope` + `MaterialApp` so the test rig
matches the runtime DI shape.

## What we do NOT test

- The `flutter_local_notifications`, `geolocator`, `connectivity_plus`
  platform channels themselves -- they are wrapped by services in
  `core/services/` and those wrappers are mocked at the boundary.
- Pixel-perfect widget snapshots -- changes that move things around
  would break them constantly. We assert on widget keys, types, and
  text content instead.
