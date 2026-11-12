import '../../domain/entities/app_settings.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<void> resetSettings();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl();

  static AppSettings _cachedSettings = AppSettings(
    updatedAt: DateTime.now(),
  );

  @override
  Future<AppSettings> getSettings() async {
    return _cachedSettings;
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    _cachedSettings = settings;
  }

  @override
  Future<void> resetSettings() async {
    _cachedSettings = AppSettings(
      updatedAt: DateTime.now(),
    );
  }
}

