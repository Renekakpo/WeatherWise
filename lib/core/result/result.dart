import '../error/app_failure.dart';

/// Sealed result type. Use case calls and repository methods return
/// [Future<Result<T>>] so call sites must explicitly handle both branches
/// (Dart 3 exhaustive switch on a sealed type).
sealed class Result<T> {
  const Result();

  /// Folds the result into a single value, forcing the caller to provide
  /// both branches.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppFailure failure) onFailure,
  });

  /// Maps the success branch to a new value, leaving the failure as-is.
  Result<R> map<R>(R Function(T data) transform);

  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  AppFailure? get failureOrNull => switch (this) {
        Success() => null,
        Failure(:final failure) => failure,
      };

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) {
    return onSuccess(data);
  }

  @override
  Result<R> map<R>(R Function(T data) transform) => Success(transform(data));

  @override
  String toString() => 'Success($data)';
}

final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  final AppFailure failure;

  @override
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) {
    return onFailure(failure);
  }

  @override
  Result<R> map<R>(R Function(T data) transform) => Failure(failure);

  @override
  String toString() => 'Failure($failure)';
}

/// Guards an async block, converting any thrown exception via
/// [mapExceptionToFailure]. Lets repository implementations stay concise.
Future<Result<T>> runCatching<T>(
  Future<T> Function() block, {
  required AppFailure Function(Object error) onError,
}) async {
  try {
    final value = await block();
    return Success(value);
  } catch (e) {
    return Failure(onError(e));
  }
}
