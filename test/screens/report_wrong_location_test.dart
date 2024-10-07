import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherwise/helpers/support_center_helper.dart';
import 'package:weatherwise/interface/email_sender.dart';
import 'package:weatherwise/screens/report_wrong_location.dart';
import 'package:weatherwise/utils/strings.dart';
import 'package:weatherwise/widgets/custom_button.dart';
import 'package:weatherwise/widgets/custom_input_field.dart';

import '../helpers/support_center_helper_test.mocks.dart';

@GenerateMocks([EmailSender, Logger])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    // Stub send method from SupportCenterHelper
    when(emailSender.send(any)).thenAnswer((_) async => true);
  });

  group('ReportWrongLocationScreen', () {
    testWidgets('renders the screen with all necessary widgets', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ReportWrongLocationScreen()));

      // Verify the AppBar title
      expect(find.text(Strings.wrongLocationLabel), findsOneWidget);

      // Verify the CustomInputFields for email and issue description
      expect(find.byType(CustomInputField), findsNWidgets(2));

      // Verify the submit button is present
      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('validates the form with invalid inputs', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ReportWrongLocationScreen()));

      // Try to submit without entering any data
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // Check for validation errors
      expect(find.text(Strings.invalidEmailErrorText), findsOneWidget);
      expect(find.text(Strings.invalidIssueDescText), findsOneWidget);
    });

    testWidgets('validates the form with valid inputs', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ReportWrongLocationScreen()));

      // Enter valid email
      await tester.enterText(find.byType(CustomInputField).first, 'test@example.com');
      await tester.pump();

      // Enter valid issue description
      await tester.enterText(find.byType(CustomInputField).last, 'Issue with location.');
      await tester.pump();

      // Try to submit the form
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // No validation error should be found
      expect(find.text('Invalid email address'), findsNothing);
      expect(find.text('Please describe the issue'), findsNothing);
    });

    testWidgets('submits the form and shows success message', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ReportWrongLocationScreen()));

      // Enter valid email and issue description
      await tester.enterText(find.byType(CustomInputField).first, 'test@example.com');
      await tester.enterText(find.byType(CustomInputField).last, 'Location issue description');
      await tester.pump();

      // Submit the form
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // Verify success message is shown
      expect(find.text('Report sent successfully!'), findsOneWidget);
    });
  });
}