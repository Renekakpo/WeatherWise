import '../../../../core/result/result.dart';
import '../entities/app_settings.dart';
import '../entities/temperature_unit.dart';
import '../repositories/settings_repository.dart';

class UpdateTemperatureUnitUseCase {
  const UpdateTemperatureUnitUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Result<AppSettings>> call(
    AppSettings current,
    TemperatureUnit unit,
  ) async {
    final updated = current.copyWith(unit: unit);
    final saved = await _repository.save(updated);
    return saved.map((_) => updated);
  }
}
