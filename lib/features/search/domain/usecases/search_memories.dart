import '../../../memories/domain/entities/memory.dart';
import '../entities/search_filter.dart';
import '../repositories/search_repository.dart';

class SearchMemories {
  SearchMemories(this._repository);

  final SearchRepository _repository;

  Future<List<Memory>> call({
    required String query,
    required SearchFilter filter,
  }) {
    return _repository.searchMemories(query: query, filter: filter);
  }
}

