import '../entities/home_summary.dart';
import '../repositories/home_repository.dart';

class GetRecentMemories {
  const GetRecentMemories(this._repository);

  final HomeRepository _repository;

  Future<List<HomeMemoryItem>> call({int limit = 5}) {
    return _repository.getRecentMemories(limit: limit);
  }
}
