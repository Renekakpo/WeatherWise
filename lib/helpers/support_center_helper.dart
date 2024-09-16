import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:logger/logger.dart';
import 'package:mailer/mailer.dart';

class SupportCenterHelper {
  static final SupportCenterHelper _instance = SupportCenterHelper._internal();

  factory SupportCenterHelper() {
    return _instance;
  }

  SupportCenterHelper._internal();

  final Logger _logger = Logger();

  late final String _supportEmail;

  void initialize() {
    _supportEmail = dotenv.env['SUPPORT_EMAIL'] ?? '';

    if (_supportEmail.isEmpty) {
      _logger.e('Support email is not set in the environment variables.');
    }
  }

  Future<void> sendSupportEmail(String userEmail, String issueDescription, BuildContext context) async {

    final Email email = Email(
      body: 'Issue Description:\n$issueDescription',
      subject: 'Wrong Location Report',
      recipients: [_supportEmail],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      _logger.i('Message sent: success');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report sent successfully!')),
      );
    } on MailerException catch (e) {
      _logger.e('Message not sent. ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send report. Please try again.')),
      );
    }
  }
}