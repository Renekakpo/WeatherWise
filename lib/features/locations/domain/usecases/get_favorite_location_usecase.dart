import '../../../../core/result/result.dart';
import '../entities/saved_location.dart';
import '../repositories/locations_repository.dart';

class GetFavoriteLocationUseCase {
  const GetFavoriteLocationUseCase(this._repository);
  final LocationsRepository _repository;

  Future<Result<SavedLocation?>> call() => _repository.getFavorite();
}
