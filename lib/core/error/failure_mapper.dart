import 'dart:async';
import 'dart:io';

import '../network/api_exception.dart';
import 'app_failure.dart';

/// Converts an arbitrary exception caught at the repository boundary into the
/// closest [AppFailure] subtype. Repositories use this so they never leak
/// transport-layer exception types into the domain.
AppFailure mapExceptionToFailure(Object error) {
  if (error is AppFailure) return error;
  if (error is ServerException) {
    return ApiFailure(error.statusCode, cause: error, message: error.message);
  }
  if (error is ParseException) {
    return ParseFailure(cause: error);
  }
  if (error is NetworkException) {
    return NetworkFailure(cause: error);
  }
  if (error is SocketException || error is HttpException) {
    return NetworkFailure(cause: error);
  }
  if (error is TimeoutException) {
    return NetworkFailure(cause: error);
  }
  if (error is FormatException) {
    return ParseFailure(cause: error);
  }
  return UnknownFailure(cause: error);
}
