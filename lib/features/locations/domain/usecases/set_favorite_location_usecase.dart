import '../../../../core/result/result.dart';
import '../repositories/locations_repository.dart';

class SetFavoriteLocationUseCase {
  const SetFavoriteLocationUseCase(this._repository);
  final LocationsRepository _repository;

  Future<Result<void>> call(int id) => _repository.setFavorite(id);
}
