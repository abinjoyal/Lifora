import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class GetMemoryById {
  const GetMemoryById(this._repository);

  final MemoryRepository _repository;

  Future<Memory?> call(String id) {
    return _repository.getMemoryById(id);
  }
}
