import '../repositories/search_repository.dart';

class RemoveRecentSearch {
  RemoveRecentSearch(this._repository);

  final SearchRepository _repository;

  Future<void> call(String query) {
    return _repository.removeRecentSearch(query);
  }
}

