import '../entities/storage_info.dart';
import '../repositories/storage_repository.dart';

class GetStorageStatus {
  const GetStorageStatus(this._repository);

  final StorageRepository _repository;

  Future<StorageInfo?> call() {
    return _repository.getCurrentStorage();
  }
}
