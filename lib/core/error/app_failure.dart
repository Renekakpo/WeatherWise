/// Domain-level error type. Repositories convert raw exceptions into one of
/// these subtypes so call sites can switch over them exhaustively (sealed +
/// pattern matching) instead of catching by exception class.
sealed class AppFailure {
  const AppFailure(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure({super.cause}) : super('Network unreachable');
}

final class ApiFailure extends AppFailure {
  const ApiFailure(this.statusCode, {super.cause, String? message})
      : super(message ?? 'API error');

  final int statusCode;

  @override
  String toString() => 'ApiFailure($statusCode): $message';
}

final class ParseFailure extends AppFailure {
  const ParseFailure({super.cause}) : super('Failed to parse server response');
}

final class CacheFailure extends AppFailure {
  const CacheFailure({super.cause}) : super('Local storage error');
}

final class PermissionDeniedFailure extends AppFailure {
  const PermissionDeniedFailure() : super('Permission denied');
}

final class LocationServiceDisabledFailure extends AppFailure {
  const LocationServiceDisabledFailure() : super('Location service disabled');
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure([String? message]) : super(message ?? 'Not found');
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure({super.cause}) : super('Unknown error');
}
