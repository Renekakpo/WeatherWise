import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_preferences_provider.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_auto_refresh_usecase.dart';
import '../../domain/usecases/update_refresh_on_the_go_usecase.dart';
import '../../domain/usecases/update_temperature_unit_usecase.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(sharedPreferencesProvider));
});

final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) {
  return GetSettingsUseCase(ref.watch(settingsRepositoryProvider));
});

final updateTemperatureUnitUseCaseProvider =
    Provider<UpdateTemperatureUnitUseCase>((ref) {
  return UpdateTemperatureUnitUseCase(ref.watch(settingsRepositoryProvider));
});

final updateAutoRefreshUseCaseProvider = Provider<UpdateAutoRefreshUseCase>((ref) {
  return UpdateAutoRefreshUseCase(ref.watch(settingsRepositoryProvider));
});

final updateRefreshOnTheGoUseCaseProvider =
    Provider<UpdateRefreshOnTheGoUseCase>((ref) {
  return UpdateRefreshOnTheGoUseCase(ref.watch(settingsRepositoryProvider));
});
