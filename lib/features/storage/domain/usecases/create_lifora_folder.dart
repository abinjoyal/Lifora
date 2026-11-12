import '../entities/storage_info.dart';
import '../repositories/storage_repository.dart';

class CreateLiforaFolder {
  const CreateLiforaFolder(this._repository);

  final StorageRepository _repository;

  Future<StorageInfo> call(String parentTreeUri) {
    return _repository.createLiforaFolder(parentTreeUri);
  }
}
