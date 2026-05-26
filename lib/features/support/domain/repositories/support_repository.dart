import '../../../../core/result/result.dart';
import '../entities/support_request.dart';

abstract interface class SupportRepository {
  Future<Result<void>> send(SupportRequest request);
}
