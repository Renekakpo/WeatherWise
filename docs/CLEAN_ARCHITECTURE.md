# Clean Architecture in WeatherWise

This document explains *why* the project is split into three layers per
feature, and how the explicit `Result<T>` + `AppFailure` types support
that split.

## Why three layers?

The split is about *direction of dependencies*, not about file count.
The domain layer has no Flutter or third-party imports. Anything that
talks to the network, the disk, or a Flutter plugin lives in `data/`.
This means:

- Replacing OpenWeather with a different weather API touches exactly
  `WeatherRemoteDataSource`, `WeatherDto`, `WeatherMapper`, and
  `WeatherRepositoryImpl`. Nothing else.
- Unit-testing `Weather`, `Forecast`, `AppSettings`, and the use cases
  needs no mock framework -- they are plain Dart.
- A future migration to a different state management library (e.g. bloc)
  would only touch the `presentation/` layer; the domain and data
  contracts are unaffected.

## Why use cases?

A use case is a one-method class that orchestrates a single business
action. They look thin, and that's the point: they make the *vocabulary*
of the app explicit. Reading `GetCurrentWeatherUseCase`,
`AddLocationFromCityUseCase`, and `SendSupportRequestUseCase` in the
domain folder tells a new contributor what the app *does* without
reading a single widget.

When a use case grows logic (combining two repositories, applying
domain rules), it has the right home for it -- not the ViewModel, not
the repository.

## Why Result + AppFailure instead of exceptions?

Exceptions are an out-of-band channel: the type signature of a function
doesn't tell you what it can throw. In a code review, that means you
can miss an error path.

`Future<Result<T>>` puts every possible outcome into the return type:

```dart
abstract interface class WeatherRepository {
  Future<Result<Weather>> getCurrentWeather({ ... });
}
```

Combined with sealed `Result<T>` and Dart 3 exhaustive switch:

```dart
switch (await repository.getCurrentWeather(...)) {
  case Success(:final data): // compiler knows data is Weather
    ...
  case Failure(:final failure): // compiler knows failure is AppFailure
    switch (failure) {
      case NetworkFailure(): ...
      case ApiFailure(:final statusCode): ...
      case PermissionDeniedFailure(): ...
      // every case must be handled, the compiler enforces it
    }
}
```

You cannot forget the failure branch, and the failure subtypes are
themselves a sealed family -- adding a new `AppFailure` subtype causes
the compiler to flag every incomplete switch in the codebase.

## Boundary contract: who can throw

| Layer | Can throw? | What |
|---|---|---|
| Data sources | yes | `NetworkException`, `ServerException`, `ParseException` |
| Repositories | no  | catch above, convert via `mapExceptionToFailure`, return `Result` |
| Use cases    | no  | pass `Result` through (or compose them) |
| ViewModels   | yes | `throw failure` so Riverpod surfaces it as `AsyncError` |

This is the only place exceptions are used as a flow-control device --
and it's contained to the boundary between business logic and UI.

## Worked example: adding a city

`AddLocationViewModel.addCity` orchestrates two use cases:

1. `GetCurrentWeatherUseCase` -- fetch the weather snapshot for the
   chosen city's coordinates.
2. `SaveLocationUseCase` -- persist a `SavedLocation` built from the
   snapshot.

Each returns a `Result`; the ViewModel folds the first, builds the
entity, hands it to the second, folds the second, and updates state.
A failure at either step rolls back to `AsyncError(failure)` so the UI
shows a SnackBar without the ViewModel ever touching an exception.

See [`add_location_view_model.dart`](../lib/features/locations/presentation/view_model/add_location_view_model.dart).

## When *not* to add use cases

The plan was "use cases systematically", but a few cases are genuinely
single delegation calls (e.g. `GetSavedLocationsUseCase` just forwards
to `repository.getAll()`). The argument for keeping them anyway:

- The domain folder lists everything the app can do, with a clear name.
- The ViewModel depends on the use case, not the repository, which
  keeps the dependency direction consistent across features.
- When the use case acquires logic (caching, validation), the call
  sites already point at it.

The cost is small -- ~10 lines per use case -- and the consistency
argument wins.
