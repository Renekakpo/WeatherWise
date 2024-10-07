import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../interface/email_sender.dart';

class FlutterEmailSenderAdapter implements EmailSender {
  @override
  Future<bool> send(Email email) async {
    try {
      FlutterEmailSender.send(email);
      return true;
    } catch (e) {
      return false;
    }
  }
}
