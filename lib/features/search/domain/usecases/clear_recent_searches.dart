import '../repositories/search_repository.dart';

class ClearRecentSearches {
  ClearRecentSearches(this._repository);

  final SearchRepository _repository;

  Future<void> call() {
    return _repository.clearRecentSearches();
  }
}

