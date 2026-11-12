import '../repositories/storage_repository.dart';

class SelectParentFolder {
  const SelectParentFolder(this._repository);

  final StorageRepository _repository;

  Future<String?> call() {
    return _repository.selectParentFolder();
  }
}
