import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class CreateMemory {
  const CreateMemory(this._repository);

  final MemoryRepository _repository;

  Future<Memory> call(Memory memory, {List<String>? newPhotoPaths}) {
    return _repository.createMemory(memory, newPhotoPaths: newPhotoPaths);
  }
}
