import '../../../../core/result/result.dart';
import '../entities/city_suggestion.dart';
import '../repositories/city_search_repository.dart';

class SearchCitiesUseCase {
  const SearchCitiesUseCase(this._repository);
  final CitySearchRepository _repository;

  Future<Result<List<CitySuggestion>>> call(String query) =>
      _repository.search(query);
}
