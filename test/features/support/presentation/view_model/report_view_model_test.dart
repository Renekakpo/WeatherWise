import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weatherwise/core/error/app_failure.dart';
import 'package:weatherwise/core/result/result.dart';
import 'package:weatherwise/features/support/domain/entities/support_request.dart';
import 'package:weatherwise/features/support/domain/repositories/support_repository.dart';
import 'package:weatherwise/features/support/presentation/providers/support_providers.dart';
import 'package:weatherwise/features/support/presentation/view_model/report_view_model.dart';

class _MockRepo extends Mock implements SupportRepository {}

class _FakeRequest extends Fake implements SupportRequest {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeRequest());
  });

  late _MockRepo repo;

  ProviderContainer makeContainer() => ProviderContainer(
        overrides: [supportRepositoryProvider.overrideWithValue(repo)],
      );

  setUp(() {
    repo = _MockRepo();
  });

  test('submit returns true and exposes AsyncData on success', () async {
    when(() => repo.send(any())).thenAnswer((_) async => const Success(null));
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(reportViewModelProvider.notifier);

    final ok = await notifier.submit(
      const SupportRequest(userEmail: 'a@b.c', description: 'd'),
    );

    expect(ok, isTrue);
    expect(container.read(reportViewModelProvider), isA<AsyncData<void>>());
  });

  test('submit returns false and exposes AsyncError on failure', () async {
    when(() => repo.send(any()))
        .thenAnswer((_) async => const Failure(NetworkFailure()));
    final container = makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(reportViewModelProvider.notifier);

    final ok = await notifier.submit(
      const SupportRequest(userEmail: 'a@b.c', description: 'd'),
    );

    expect(ok, isFalse);
    final state = container.read(reportViewModelProvider);
    expect(state, isA<AsyncError>());
    expect(state.error, isA<NetworkFailure>());
  });
}
