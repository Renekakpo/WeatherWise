import '../../../../core/result/result.dart';
import '../entities/saved_location.dart';
import '../repositories/locations_repository.dart';

class GetSavedLocationsUseCase {
  const GetSavedLocationsUseCase(this._repository);
  final LocationsRepository _repository;

  Future<Result<List<SavedLocation>>> call() => _repository.getAll();
}
