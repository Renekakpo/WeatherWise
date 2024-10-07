import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:logger/logger.dart';
import 'package:mailer/mailer.dart';

import '../adapter/flutter_email_sender_adapter.dart';
import '../interface/email_sender.dart';

class SupportCenterHelper {
  static final SupportCenterHelper _instance = SupportCenterHelper._internal();

  factory SupportCenterHelper({EmailSender? emailSender, Logger? logger}) {
    if (emailSender != null) {
      _instance._emailSender = emailSender;
    }

    if (logger != null) {
      _instance._logger = logger; // Use the injected logger
    }

    return _instance;
  }

  SupportCenterHelper._internal();

  late Logger _logger = Logger();

  late final String _supportEmail;

  EmailSender _emailSender =
      FlutterEmailSenderAdapter(); // Default implementation

  void initialize() {
    _supportEmail = dotenv.env['SUPPORT_EMAIL'] ?? '';

    if (_supportEmail.isEmpty) {
      _logger.e('Support email is not set in the environment variables.');
    }
  }

  Future<bool> sendSupportEmail(
      String userEmail, String issueDescription) async {
    final Email email = Email(
      body: 'Issue Description:\n$issueDescription',
      subject: 'Wrong Location Report',
      recipients: [_supportEmail],
      isHTML: false,
    );

    try {
      final res = await _emailSender.send(email);
      _logger.i('Message sent: success');
      return res;
    } on MailerException catch (e) {
      _logger.e('Message not sent. ${e.toString()}');
      return false;
    }
  }
}
