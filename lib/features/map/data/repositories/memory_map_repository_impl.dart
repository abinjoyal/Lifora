import 'dart:math';
import '../../../memories/domain/entities/memory.dart';
import '../../../memories/domain/repositories/memory_repository.dart';
import '../../domain/entities/map_filter.dart';
import '../../domain/entities/map_marker_group.dart';
import '../../domain/repositories/memory_map_repository.dart';

class MemoryMapRepositoryImpl implements MemoryMapRepository {
  MemoryMapRepositoryImpl({required this.memoryRepository});

  final MemoryRepository memoryRepository;

  // Threshold for grouping nearby memories into one cluster marker (~80 meters)
  static const double _clusterDistanceThreshold = 0.0008;

  @override
  Future<List<MapMarkerGroup>> getMemoryMarkers({MapFilter? filter}) async {
    final allMemories = await memoryRepository.getAllMemories();

    // 1. Filter memories with valid coordinates and matching criteria
    final matchingMemories = allMemories.where((m) {
      if (filter != null) {
        return filter.matches(m);
      }
      return m.location?.hasCoordinates == true;
    }).toList();

    // 2. Group nearby memories into cluster groups
    final List<_MutableMarkerCluster> clusters = [];

    for (final memory in matchingMemories) {
      final lat = memory.location!.latitude!;
      final lon = memory.location!.longitude!;

      _MutableMarkerCluster? targetCluster;
      for (final cluster in clusters) {
        final dLat = (cluster.latitude - lat).abs();
        final dLon = (cluster.longitude - lon).abs();
        final distance = sqrt(dLat * dLat + dLon * dLon);

        if (distance <= _clusterDistanceThreshold) {
          targetCluster = cluster;
          break;
        }
      }

      if (targetCluster != null) {
        targetCluster.memories.add(memory);
      } else {
        clusters.add(
          _MutableMarkerCluster(
            id: 'cluster_${lat.toStringAsFixed(5)}_${lon.toStringAsFixed(5)}',
            latitude: lat,
            longitude: lon,
            locationName: memory.location?.name ?? 'Memory Location',
            address: memory.location?.address,
            memories: [memory],
          ),
        );
      }
    }

    // 3. Convert to immutable MapMarkerGroup records
    return clusters.map((c) {
      return MapMarkerGroup(
        id: c.id,
        latitude: c.latitude,
        longitude: c.longitude,
        locationName: c.locationName,
        address: c.address,
        memories: c.memories,
      );
    }).toList();
  }

  @override
  Future<List<Memory>> searchMemoriesByLocation(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return const [];

    final allMemories = await memoryRepository.getAllMemories();
    return allMemories.where((m) {
      if (m.location?.hasCoordinates != true) return false;

      final locName = m.location?.name.toLowerCase() ?? '';
      final address = m.location?.address?.toLowerCase() ?? '';
      final title = m.title.toLowerCase();

      return locName.contains(cleanQuery) ||
          address.contains(cleanQuery) ||
          title.contains(cleanQuery);
    }).toList();
  }
}

class _MutableMarkerCluster {
  _MutableMarkerCluster({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    this.address,
    required this.memories,
  });

  final String id;
  final double latitude;
  final double longitude;
  final String locationName;
  final String? address;
  final List<Memory> memories;
}

