import '../entities/storage_info.dart';
import '../repositories/storage_repository.dart';

class ReconnectStorage {
  const ReconnectStorage(this._repository);

  final StorageRepository _repository;

  Future<StorageInfo> call(String treeUri) {
    return _repository.reconnectStorage(treeUri);
  }
}
