import '../../../../core/result/result.dart';
import '../entities/support_request.dart';
import '../repositories/support_repository.dart';

class SendSupportRequestUseCase {
  const SendSupportRequestUseCase(this._repository);

  final SupportRepository _repository;

  Future<Result<void>> call(SupportRequest request) =>
      _repository.send(request);
}
