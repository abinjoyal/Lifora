import '../entities/map_filter.dart';
import '../entities/map_marker_group.dart';
import '../repositories/memory_map_repository.dart';

class GetMemoryMapMarkers {
  GetMemoryMapMarkers(this._repository);

  final MemoryMapRepository _repository;

  Future<List<MapMarkerGroup>> call({MapFilter? filter}) {
    return _repository.getMemoryMarkers(filter: filter);
  }
}

