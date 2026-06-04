import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/http_client.dart';
import '../../../../core/providers/env_provider.dart';
import '../../../../core/storage/database/app_database.dart';
import '../../data/datasources/city_search_remote_data_source.dart';
import '../../data/datasources/locations_local_data_source.dart';
import '../../data/repositories/city_search_repository_impl.dart';
import '../../data/repositories/locations_repository_impl.dart';
import '../../domain/repositories/city_search_repository.dart';
import '../../domain/repositories/locations_repository.dart';
import '../../domain/usecases/delete_all_locations_usecase.dart';
import '../../domain/usecases/delete_location_usecase.dart';
import '../../domain/usecases/get_favorite_location_usecase.dart';
import '../../domain/usecases/get_saved_locations_usecase.dart';
import '../../domain/usecases/save_location_usecase.dart';
import '../../domain/usecases/search_cities_usecase.dart';
import '../../domain/usecases/set_favorite_location_usecase.dart';

final locationsLocalDataSourceProvider =
    Provider<LocationsLocalDataSource>((ref) {
  // appDatabaseProvider is a FutureProvider<Database>; the data source
  // accepts a Future<Database> so we hand it the future directly.
  return LocationsLocalDataSource(ref.watch(appDatabaseProvider.future));
});

final locationsRepositoryProvider = Provider<LocationsRepository>((ref) {
  return LocationsRepositoryImpl(ref.watch(locationsLocalDataSourceProvider));
});

final citySearchRemoteDataSourceProvider =
    Provider<CitySearchRemoteDataSource>((ref) {
  return CitySearchRemoteDataSource(
    httpClient: ref.watch(httpClientProvider),
    username: ref.watch(envProvider).geonamesUsername,
  );
});

final citySearchRepositoryProvider = Provider<CitySearchRepository>((ref) {
  return CitySearchRepositoryImpl(ref.watch(citySearchRemoteDataSourceProvider));
});

// Use cases
final getSavedLocationsUseCaseProvider = Provider<GetSavedLocationsUseCase>((ref) {
  return GetSavedLocationsUseCase(ref.watch(locationsRepositoryProvider));
});

final getFavoriteLocationUseCaseProvider =
    Provider<GetFavoriteLocationUseCase>((ref) {
  return GetFavoriteLocationUseCase(ref.watch(locationsRepositoryProvider));
});

final saveLocationUseCaseProvider = Provider<SaveLocationUseCase>((ref) {
  return SaveLocationUseCase(ref.watch(locationsRepositoryProvider));
});

final deleteLocationUseCaseProvider = Provider<DeleteLocationUseCase>((ref) {
  return DeleteLocationUseCase(ref.watch(locationsRepositoryProvider));
});

final deleteAllLocationsUseCaseProvider =
    Provider<DeleteAllLocationsUseCase>((ref) {
  return DeleteAllLocationsUseCase(ref.watch(locationsRepositoryProvider));
});

final setFavoriteLocationUseCaseProvider =
    Provider<SetFavoriteLocationUseCase>((ref) {
  return SetFavoriteLocationUseCase(ref.watch(locationsRepositoryProvider));
});

final searchCitiesUseCaseProvider = Provider<SearchCitiesUseCase>((ref) {
  return SearchCitiesUseCase(ref.watch(citySearchRepositoryProvider));
});
