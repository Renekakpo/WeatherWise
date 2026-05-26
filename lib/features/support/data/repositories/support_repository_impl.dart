import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/support_request.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/email_sender_data_source.dart';

class SupportRepositoryImpl implements SupportRepository {
  const SupportRepositoryImpl({
    required EmailSenderDataSource emailSender,
    required String supportEmail,
  })  : _emailSender = emailSender,
        _supportEmail = supportEmail;

  final EmailSenderDataSource _emailSender;
  final String _supportEmail;

  @override
  Future<Result<void>> send(SupportRequest request) async {
    if (_supportEmail.isEmpty) {
      return const Failure(
        ApiFailure(0, message: 'Support email not configured'),
      );
    }
    final email = Email(
      body: 'Issue Description:\n${request.description}\n\n'
          'Reporter: ${request.userEmail}',
      subject: 'Wrong Location Report',
      recipients: [_supportEmail],
      isHTML: false,
    );

    try {
      final ok = await _emailSender.send(email);
      if (!ok) {
        return const Failure(UnknownFailure());
      }
      return const Success(null);
    } on MailerException catch (e) {
      return Failure(NetworkFailure(cause: e));
    } catch (e) {
      return Failure(UnknownFailure(cause: e));
    }
  }
}
