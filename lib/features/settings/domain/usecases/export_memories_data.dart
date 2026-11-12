import '../repositories/settings_repository.dart';

class ExportMemoriesData {
  ExportMemoriesData(this._repository);

  final SettingsRepository _repository;

  Future<String> call() {
    return _repository.exportMemoriesJson();
  }
}

