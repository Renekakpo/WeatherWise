import '../../../../core/result/result.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class UpdateAutoRefreshUseCase {
  const UpdateAutoRefreshUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Result<AppSettings>> call(AppSettings current, int hours) async {
    final updated = current.copyWith(autoRefreshHours: hours);
    final saved = await _repository.save(updated);
    return saved.map((_) => updated);
  }
}
