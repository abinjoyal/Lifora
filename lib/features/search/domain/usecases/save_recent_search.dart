import '../repositories/search_repository.dart';

class SaveRecentSearch {
  SaveRecentSearch(this._repository);

  final SearchRepository _repository;

  Future<void> call(String query) {
    return _repository.saveRecentSearch(query);
  }
}

