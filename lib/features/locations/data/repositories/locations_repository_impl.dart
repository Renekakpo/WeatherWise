import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/saved_location.dart';
import '../../domain/repositories/locations_repository.dart';
import '../datasources/locations_local_data_source.dart';

class LocationsRepositoryImpl implements LocationsRepository {
  const LocationsRepositoryImpl(this._dataSource);

  final LocationsLocalDataSource _dataSource;

  @override
  Future<Result<List<SavedLocation>>> getAll() {
    return runCatching(_dataSource.getAll, onError: mapExceptionToFailure);
  }

  @override
  Future<Result<SavedLocation?>> getFavorite() {
    return runCatching(_dataSource.getFavorite, onError: mapExceptionToFailure);
  }

  @override
  Future<Result<void>> save(SavedLocation location) {
    return runCatching(
      () => _dataSource.insert(location),
      onError: mapExceptionToFailure,
    );
  }

  @override
  Future<Result<void>> delete(int id) {
    return runCatching(
      () => _dataSource.delete(id),
      onError: mapExceptionToFailure,
    );
  }

  @override
  Future<Result<void>> deleteAll() {
    return runCatching(
      _dataSource.deleteAll,
      onError: mapExceptionToFailure,
    );
  }

  @override
  Future<Result<void>> setFavorite(int id) {
    return runCatching(
      () => _dataSource.setFavorite(id),
      onError: mapExceptionToFailure,
    );
  }
}
