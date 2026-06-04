import '../../../../core/result/result.dart';
import '../entities/saved_location.dart';

abstract interface class LocationsRepository {
  Future<Result<List<SavedLocation>>> getAll();
  Future<Result<SavedLocation?>> getFavorite();
  Future<Result<void>> save(SavedLocation location);
  Future<Result<void>> delete(int id);
  Future<Result<void>> deleteAll();
  Future<Result<void>> setFavorite(int id);
}
