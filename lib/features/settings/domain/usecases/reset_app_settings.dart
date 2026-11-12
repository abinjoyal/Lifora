import '../repositories/settings_repository.dart';

class ResetAppSettings {
  ResetAppSettings(this._repository);

  final SettingsRepository _repository;

  Future<void> call() {
    return _repository.resetSettings();
  }
}

