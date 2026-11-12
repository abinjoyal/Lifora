import '../../../memories/domain/entities/memory.dart';
import '../entities/map_filter.dart';
import '../entities/map_marker_group.dart';

abstract class MemoryMapRepository {
  Future<List<MapMarkerGroup>> getMemoryMarkers({MapFilter? filter});

  Future<List<Memory>> searchMemoriesByLocation(String query);
}

