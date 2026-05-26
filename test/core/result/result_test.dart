import 'package:flutter_test/flutter_test.dart';
import 'package:weatherwise/core/error/app_failure.dart';
import 'package:weatherwise/core/result/result.dart';

void main() {
  group('Result', () {
    test('Success.fold calls onSuccess', () {
      const result = Success<int>(42);
      final folded = result.fold(
        onSuccess: (v) => 'ok $v',
        onFailure: (_) => 'fail',
      );
      expect(folded, 'ok 42');
    });

    test('Failure.fold calls onFailure', () {
      const failure = NetworkFailure();
      const result = Failure<int>(failure);
      final folded = result.fold(
        onSuccess: (_) => 'ok',
        onFailure: (f) => f.message,
      );
      expect(folded, 'Network unreachable');
    });

    test('Success.map transforms value', () {
      const result = Success<int>(2);
      final mapped = result.map((v) => v * 10);
      expect(mapped, isA<Success<int>>());
      expect(mapped.dataOrNull, 20);
    });

    test('Failure.map preserves failure', () {
      const result = Failure<int>(NetworkFailure());
      final mapped = result.map((v) => v.toString());
      expect(mapped, isA<Failure<String>>());
      expect(mapped.failureOrNull, isA<NetworkFailure>());
    });

    test('isSuccess / isFailure flags', () {
      expect(const Success<int>(1).isSuccess, isTrue);
      expect(const Success<int>(1).isFailure, isFalse);
      expect(const Failure<int>(NetworkFailure()).isSuccess, isFalse);
      expect(const Failure<int>(NetworkFailure()).isFailure, isTrue);
    });

    test('exhaustive switch on sealed type compiles and works', () {
      Result<int> r = const Success(7);
      final label = switch (r) {
        Success(:final data) => 'value=$data',
        Failure(:final failure) => 'err=${failure.message}',
      };
      expect(label, 'value=7');

      const Result<int> r2 = Failure(CacheFailure());
      final label2 = switch (r2) {
        Success(:final data) => 'value=$data',
        Failure(:final failure) => 'err=${failure.message}',
      };
      expect(label2, 'err=Local storage error');
    });

    group('runCatching', () {
      test('wraps success', () async {
        final result = await runCatching<int>(
          () async => 5,
          onError: (e) => UnknownFailure(cause: e),
        );
        expect(result.dataOrNull, 5);
      });

      test('catches exception and maps to failure', () async {
        final result = await runCatching<int>(
          () async => throw Exception('boom'),
          onError: (e) => const CacheFailure(),
        );
        expect(result, isA<Failure<int>>());
        expect(result.failureOrNull, isA<CacheFailure>());
      });
    });
  });
}
