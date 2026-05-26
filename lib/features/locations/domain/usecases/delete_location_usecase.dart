import '../../../../core/result/result.dart';
import '../repositories/locations_repository.dart';

class DeleteLocationUseCase {
  const DeleteLocationUseCase(this._repository);
  final LocationsRepository _repository;

  Future<Result<void>> call(int id) => _repository.delete(id);
}
