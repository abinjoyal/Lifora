import '../entities/storage_info.dart';
import '../repositories/storage_repository.dart';

class InitializeStorage {
  const InitializeStorage(this._repository);

  final StorageRepository _repository;

  Future<StorageInfo> call(String targetTreeUri) {
    return _repository.initializeStorage(targetTreeUri);
  }
}
