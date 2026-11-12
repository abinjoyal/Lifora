import '../entities/search_suggestion.dart';
import '../repositories/search_repository.dart';

class GetSearchSuggestions {
  GetSearchSuggestions(this._repository);

  final SearchRepository _repository;

  Future<List<SearchSuggestion>> call(String query) {
    return _repository.getSuggestions(query);
  }
}

