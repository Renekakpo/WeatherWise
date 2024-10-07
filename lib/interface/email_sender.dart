import 'package:flutter_email_sender/flutter_email_sender.dart';

abstract class EmailSender {
  Future<bool> send(Email email);
}