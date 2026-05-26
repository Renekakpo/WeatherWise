import '../../../../core/result/result.dart';
import '../repositories/locations_repository.dart';

class DeleteAllLocationsUseCase {
  const DeleteAllLocationsUseCase(this._repository);
  final LocationsRepository _repository;

  Future<Result<void>> call() => _repository.deleteAll();
}
