/// Raised by remote data sources when the network round-trip fails or the
/// server returns an unsuccessful status code. Mapped to AppFailure at the
/// repository boundary.
sealed class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends ApiException {
  const NetworkException([super.message = 'Network unreachable']);
}

class ServerException extends ApiException {
  const ServerException(this.statusCode, [super.message = 'Server error'])
      : super();

  final int statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class ParseException extends ApiException {
  const ParseException([super.message = 'Failed to parse response']);
}
