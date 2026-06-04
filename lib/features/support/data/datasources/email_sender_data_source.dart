import 'package:flutter_email_sender/flutter_email_sender.dart';

/// Abstraction over the email-sending plugin so the repository can be tested
/// without going through the real platform channel.
abstract interface class EmailSenderDataSource {
  Future<bool> send(Email email);
}

class FlutterEmailSenderDataSource implements EmailSenderDataSource {
  const FlutterEmailSenderDataSource();

  @override
  Future<bool> send(Email email) async {
    try {
      await FlutterEmailSender.send(email);
      return true;
    } catch (_) {
      return false;
    }
  }
}
