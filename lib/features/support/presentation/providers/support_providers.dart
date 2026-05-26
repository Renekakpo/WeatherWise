import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/env_provider.dart';
import '../../data/datasources/email_sender_data_source.dart';
import '../../data/repositories/support_repository_impl.dart';
import '../../domain/repositories/support_repository.dart';
import '../../domain/usecases/send_support_request_usecase.dart';

final emailSenderDataSourceProvider = Provider<EmailSenderDataSource>((_) {
  return const FlutterEmailSenderDataSource();
});

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepositoryImpl(
    emailSender: ref.watch(emailSenderDataSourceProvider),
    supportEmail: ref.watch(envProvider).supportEmail,
  );
});

final sendSupportRequestUseCaseProvider =
    Provider<SendSupportRequestUseCase>((ref) {
  return SendSupportRequestUseCase(ref.watch(supportRepositoryProvider));
});
