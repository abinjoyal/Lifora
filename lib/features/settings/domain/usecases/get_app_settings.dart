import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class GetAppSettings {
  GetAppSettings(this._repository);

  final SettingsRepository _repository;

  Future<AppSettings> call() {
    return _repository.getSettings();
  }
}

