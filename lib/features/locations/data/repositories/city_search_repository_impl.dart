import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/city_suggestion.dart';
import '../../domain/repositories/city_search_repository.dart';
import '../datasources/city_search_remote_data_source.dart';

class CitySearchRepositoryImpl implements CitySearchRepository {
  const CitySearchRepositoryImpl(this._dataSource);

  final CitySearchRemoteDataSource _dataSource;

  @override
  Future<Result<List<CitySuggestion>>> search(String query) async {
    return runCatching(
      () async {
        final dtos = await _dataSource.search(query);
        return dtos.map((d) => d.toEntity()).toList();
      },
      onError: mapExceptionToFailure,
    );
  }
}
