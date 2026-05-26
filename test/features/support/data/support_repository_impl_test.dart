import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weatherwise/core/error/app_failure.dart';
import 'package:weatherwise/core/result/result.dart';
import 'package:weatherwise/features/support/data/datasources/email_sender_data_source.dart';
import 'package:weatherwise/features/support/data/repositories/support_repository_impl.dart';
import 'package:weatherwise/features/support/domain/entities/support_request.dart';

class _MockSender extends Mock implements EmailSenderDataSource {}

class _FakeEmail extends Fake implements Email {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeEmail());
  });

  late _MockSender sender;

  setUp(() {
    sender = _MockSender();
  });

  test('returns ApiFailure when support email is not configured', () async {
    final repo =
        SupportRepositoryImpl(emailSender: sender, supportEmail: '');
    final result = await repo.send(
      const SupportRequest(userEmail: 'a@b.c', description: 'oops'),
    );
    expect(result.isFailure, isTrue);
    expect(result.failureOrNull, isA<ApiFailure>());
    expect(result.failureOrNull!.message, 'Support email not configured');
    verifyNever(() => sender.send(any()));
  });

  test('returns Success when sender succeeds', () async {
    when(() => sender.send(any())).thenAnswer((_) async => true);
    final repo = SupportRepositoryImpl(
      emailSender: sender,
      supportEmail: 'support@app.com',
    );
    final result = await repo.send(
      const SupportRequest(userEmail: 'a@b.c', description: 'oops'),
    );
    expect(result.isSuccess, isTrue);
  });

  test('returns UnknownFailure when sender returns false', () async {
    when(() => sender.send(any())).thenAnswer((_) async => false);
    final repo = SupportRepositoryImpl(
      emailSender: sender,
      supportEmail: 'support@app.com',
    );
    final result = await repo.send(
      const SupportRequest(userEmail: 'a@b.c', description: 'oops'),
    );
    expect(result.failureOrNull, isA<UnknownFailure>());
  });

  test('maps generic exception to UnknownFailure', () async {
    when(() => sender.send(any())).thenThrow(StateError('bad state'));
    final repo = SupportRepositoryImpl(
      emailSender: sender,
      supportEmail: 'support@app.com',
    );
    final result = await repo.send(
      const SupportRequest(userEmail: 'a@b.c', description: 'oops'),
    );
    expect(result.failureOrNull, isA<UnknownFailure>());
  });
}
