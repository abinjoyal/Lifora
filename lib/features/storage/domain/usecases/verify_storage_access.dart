import '../repositories/storage_repository.dart';

class VerifyStorageAccess {
  const VerifyStorageAccess(this._repository);

  final StorageRepository _repository;

  Future<bool> call(String treeUri) {
    return _repository.verifyStorageAccess(treeUri);
  }
}
