import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/support_request.dart';
import '../providers/support_providers.dart';

/// Tracks the lifecycle of submitting a support request.
class ReportViewModel extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submit(SupportRequest request) async {
    state = const AsyncLoading();
    final result =
        await ref.read(sendSupportRequestUseCaseProvider)(request);
    return result.fold(
      onSuccess: (_) {
        state = const AsyncData(null);
        return true;
      },
      onFailure: (f) {
        state = AsyncError(f, StackTrace.current);
        return false;
      },
    );
  }
}

final reportViewModelProvider =
    AsyncNotifierProvider.autoDispose<ReportViewModel, void>(
  ReportViewModel.new,
);
