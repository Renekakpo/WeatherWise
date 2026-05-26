# Architecture

## Overview

WeatherWise applies a **Clean Architecture, feature-first** layout
powered by **Riverpod** for state management and dependency injection.
Each feature is fully autonomous: a `data/` layer that talks to the
outside world (HTTP, sqlite, plugins), a `domain/` layer that holds the
business contracts and pure rules, and a `presentation/` layer that
binds Flutter widgets to ViewModels.

```
┌──────────────────────────────────────────────────────────────┐
│  PRESENTATION   ConsumerWidget / ConsumerStatefulWidget      │
│                 ViewModels (Notifier / AsyncNotifier)        │
│                                                              │
│                 ref.watch / ref.read                         │
│                          │                                   │
│                          ▼                                   │
│  DOMAIN         Entities (immutable)                         │
│                 Repositories (abstract interfaces)           │
│                 Use cases (single-action call-sites)         │
│                                                              │
│                          ▲                                   │
│                          │ implemented by                    │
│                          │                                   │
│  DATA           Repository implementations                   │
│                 Data sources (HTTP / sqlite / plugins)       │
│                 DTOs + mappers (DTO → Entity)                │
└──────────────────────────────────────────────────────────────┘
```

## Dependency rule

- `presentation` may import from `domain`, `core`, and `shared`. It
  never imports `data`.
- `domain` has zero Flutter or third-party imports (only `core/utils`
  and `core/result` if needed). It defines the contracts the rest of
  the app implements.
- `data` may import from `domain` (to implement contracts) and `core`
  (HTTP client, error mapping, storage).
- Features do not import each other directly. Cross-feature
  communication goes through providers exposed at the feature
  boundary (e.g. `favoriteLocationProvider` lives in `locations` and
  is consumed by `weather`).

## Top-level layout

```
lib/
├── main.dart                     # runApp(ProviderScope(...))
├── app/
│   ├── app.dart                  # MaterialApp.router + theme
│   ├── bootstrap.dart            # WidgetsFlutterBinding + prefs + dotenv
│   ├── router/                   # GoRouter + AppRoute enum
│   └── theme/                    # AppColors
│
├── core/
│   ├── constants/                # Strings + app constants
│   ├── error/                    # AppFailure sealed + mapper
│   ├── network/                  # http.Client provider + ApiException
│   ├── providers/                # sharedPreferences, env, etc.
│   ├── result/                   # sealed Result<T>
│   ├── services/                 # PermissionService, GeolocatorService, ...
│   ├── storage/{prefs,database}/ # PrefsKeys + sqflite db provider
│   └── utils/                    # date_formatter, weather_icon_mapper, ...
│
├── features/
│   ├── splash/    presentation/
│   ├── weather/   data + domain + presentation/
│   ├── locations/ data + domain + presentation/
│   ├── settings/  data + domain + presentation/
│   └── support/   data + domain + presentation/
│
└── shared/
    └── widgets/                  # Cross-feature UI widgets
```

## Feature-level layout

Each feature follows the same template:

```
features/<feature>/
├── data/
│   ├── datasources/    # raw HTTP / sqlite calls
│   ├── dtos/           # JSON parsers (no domain types)
│   ├── mappers/        # DTO -> Entity
│   └── repositories/   # implements domain contracts
├── domain/
│   ├── entities/       # immutable value objects, no Flutter
│   ├── repositories/   # abstract interfaces
│   └── usecases/       # single-action call-sites
└── presentation/
    ├── providers/      # Riverpod providers wiring DI
    ├── view_model/     # Notifier / AsyncNotifier classes + state types
    ├── widgets/        # feature-local widgets
    └── *_screen.dart   # the routable screens
```

## Error handling: Result + AppFailure

Repositories and use cases return `Future<Result<T>>` -- never throw,
never return `null`. `Result<T>` is sealed:

```dart
sealed class Result<T> { ... }
final class Success<T> extends Result<T> { final T data; }
final class Failure<T> extends Result<T> { final AppFailure failure; }
```

`AppFailure` is also sealed -- the UI distinguishes between
`NetworkFailure`, `ApiFailure(statusCode)`, `ParseFailure`,
`CacheFailure`, `PermissionDeniedFailure`,
`LocationServiceDisabledFailure`, `NotFoundFailure`, `UnknownFailure`.
Data sources throw plain exceptions (`NetworkException`,
`ServerException`, `ParseException`) which the repository converts via
`mapExceptionToFailure` so transport-layer types never leak into the
domain.

ViewModels then `fold` the result into Riverpod's native
`AsyncValue<T>` so the UI's `.when(loading, error, data)` works
uniformly.

## Navigation

Navigation goes through **go_router** behind a typed `AppRoute` enum.
Cross-screen "return-and-refresh" is no longer signaled by
`Navigator.pop(context, true)`; instead the calling screen
`ref.invalidate(...)`'s the relevant providers after `context.pushNamed`
returns. See [`lib/app/router/app_router.dart`](../lib/app/router/app_router.dart).

## Bootstrap & DI

`bootstrap()` runs every asynchronous initialization step (Flutter
binding, `SharedPreferences.getInstance()`, `dotenv.load(.env)`),
returns the resolved instances, and the entry point seeds
`ProviderScope.overrides` with them. The
`sharedPreferencesProvider` *throws* unless overridden -- missing
initialization fails loudly rather than silently.

## Testing

- Pure logic (entities, mappers, use cases, repositories) is unit
  tested with `flutter_test` + `mocktail`.
- ViewModels are tested with `ProviderContainer` overrides on the
  repository / use case providers.
- Database tests use `sqflite_common_ffi` with an in-memory database.
- Widget tests use `test/helpers/pump_app.dart` which mounts a
  `ProviderScope` + `MaterialApp` with caller-supplied overrides.

See [TESTING.md](TESTING.md) for the full conventions.
