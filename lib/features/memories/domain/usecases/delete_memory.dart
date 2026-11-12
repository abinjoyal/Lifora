import '../repositories/memory_repository.dart';

class DeleteMemory {
  const DeleteMemory(this._repository);

  final MemoryRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteMemory(id);
  }
}
