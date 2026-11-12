import '../repositories/search_repository.dart';

class GetRecentSearches {
  GetRecentSearches(this._repository);

  final SearchRepository _repository;

  Future<List<String>> call() {
    return _repository.getRecentSearches();
  }
}

