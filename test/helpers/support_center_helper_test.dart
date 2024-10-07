import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/src/entities/problem.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherwise/helpers/support_center_helper.dart';
import 'package:weatherwise/interface/email_sender.dart';

import 'support_center_helper_test.mocks.dart';

class FakeMailerException implements MailerException {
  @override
  String toString() => 'FakeMailerException: Simulated failure';

  @override
  // TODO: implement message
  String get message => throw UnimplementedError();

  @override
  // TODO: implement problems
  List<Problem> get problems => throw UnimplementedError();
}

@GenerateMocks([EmailSender, Logger])
void main() {
  late SupportCenterHelper supportCenterHelper;

  late MockEmailSender emailSender;
  late MockLogger logger;

  setUpAll(() {
    logger = MockLogger();
    emailSender = MockEmailSender();

    supportCenterHelper =
        SupportCenterHelper(emailSender: emailSender, logger: logger);

    // Load the environment variables before running tests
    dotenv.testLoad(fileInput: '''SUPPORT_EMAIL': 'support@example.com''');

    // Call initialize only once for all test cases
    supportCenterHelper.initialize();
  });

  group('initialize', () {
    test('should log error when support email is not set', () {
      // Simulate missing email in environment variables
      dotenv.testLoad(fileInput: '''SUPPORT_EMAIL': '''); // No SUPPORT_EMAIL

      // Check if the logger error is called with the correct message
      verify(logger.e('Support email is not set in the environment variables.'))
          .called(1);
    });

    test('should not log error when support email is set', () {
      // Logger should not log any error
      verifyNever(logger.e(any));
    });
  });

  group('sendSupportEmail', () {
    const userEmail = 'user@example.com';
    const issueDescription = 'This is a test issue.';

    test('should send email successfully and log success message', () async {
      // Simulate successful email send
      when(emailSender.send(any)).thenAnswer((_) async => true);

      final result = await supportCenterHelper.sendSupportEmail(
          userEmail, issueDescription);

      // Verify email send method is called
      verify(emailSender.send(any)).called(1);

      // Verify the logger logs success message
      verify(logger.i('Message sent: success')).called(1);

      expect(result, isTrue);
    });

    test('should handle MailerException and log error', () async {
      // Simulate a failure in sending email
      when(emailSender.send(any)).thenThrow(FakeMailerException());

      final result = await supportCenterHelper.sendSupportEmail(
          userEmail, issueDescription);

      // Verify email send method is called
      verify(emailSender.send(any)).called(1);

      // Verify the logger logs failure message
      verify(logger
              .e('Message not sent. FakeMailerException: Simulated failure'))
          .called(1);

      expect(result, isFalse);
    });
  });
}
