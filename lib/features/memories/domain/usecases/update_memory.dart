import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class UpdateMemory {
  const UpdateMemory(this._repository);

  final MemoryRepository _repository;

  Future<Memory> call(
    Memory memory, {
    List<String>? newPhotoPaths,
    List<String>? removedPhotoIds,
  }) {
    return _repository.updateMemory(
      memory,
      newPhotoPaths: newPhotoPaths,
      removedPhotoIds: removedPhotoIds,
    );
  }
}
