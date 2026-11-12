import '../repositories/home_repository.dart';

class GetMemoryStatistics {
  const GetMemoryStatistics(this._repository);

  final HomeRepository _repository;

  Future<Map<String, int>> call() {
    return _repository.getMemoryStatistics();
  }
}
