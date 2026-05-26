import '../../../../core/result/result.dart';
import '../entities/city_suggestion.dart';

abstract interface class CitySearchRepository {
  Future<Result<List<CitySuggestion>>> search(String query);
}
