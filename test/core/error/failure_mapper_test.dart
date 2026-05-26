import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:weatherwise/core/error/app_failure.dart';
import 'package:weatherwise/core/error/failure_mapper.dart';
import 'package:weatherwise/core/network/api_exception.dart';

void main() {
  group('mapExceptionToFailure', () {
    test('passes through AppFailure unchanged', () {
      const original = CacheFailure();
      expect(mapExceptionToFailure(original), same(original));
    });

    test('ServerException -> ApiFailure with status code', () {
      final failure = mapExceptionToFailure(const ServerException(503, 'down'));
      expect(failure, isA<ApiFailure>());
      expect((failure as ApiFailure).statusCode, 503);
      expect(failure.message, 'down');
    });

    test('ParseException -> ParseFailure', () {
      expect(
        mapExceptionToFailure(const ParseException()),
        isA<ParseFailure>(),
      );
    });

    test('NetworkException -> NetworkFailure', () {
      expect(
        mapExceptionToFailure(const NetworkException()),
        isA<NetworkFailure>(),
      );
    });

    test('SocketException -> NetworkFailure', () {
      expect(
        mapExceptionToFailure(const SocketException('no network')),
        isA<NetworkFailure>(),
      );
    });

    test('TimeoutException -> NetworkFailure', () {
      expect(
        mapExceptionToFailure(TimeoutException('slow')),
        isA<NetworkFailure>(),
      );
    });

    test('FormatException -> ParseFailure', () {
      expect(
        mapExceptionToFailure(const FormatException('bad json')),
        isA<ParseFailure>(),
      );
    });

    test('generic exception -> UnknownFailure', () {
      expect(
        mapExceptionToFailure(StateError('oops')),
        isA<UnknownFailure>(),
      );
    });
  });
}
