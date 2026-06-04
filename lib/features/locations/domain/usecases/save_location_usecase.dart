import '../../../../core/result/result.dart';
import '../entities/saved_location.dart';
import '../repositories/locations_repository.dart';

class SaveLocationUseCase {
  const SaveLocationUseCase(this._repository);
  final LocationsRepository _repository;

  Future<Result<void>> call(SavedLocation location) => _repository.save(location);
}
