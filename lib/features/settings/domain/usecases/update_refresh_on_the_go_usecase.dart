import '../../../../core/result/result.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class UpdateRefreshOnTheGoUseCase {
  const UpdateRefreshOnTheGoUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Result<AppSettings>> call(AppSettings current, bool value) async {
    final updated = current.copyWith(refreshOnTheGo: value);
    final saved = await _repository.save(updated);
    return saved.map((_) => updated);
  }
}
