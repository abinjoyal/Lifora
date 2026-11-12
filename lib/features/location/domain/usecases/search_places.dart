import '../entities/memory_location.dart';
import '../repositories/location_repository.dart';

class SearchPlaces {
  SearchPlaces(this._repository);

  final LocationRepository _repository;

  Future<List<MemoryLocation>> call(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return Future.value([]);
    return _repository.searchPlaces(trimmed);
  }
}

