import 'package:latlong2/latlong.dart';
import '../../../memories/domain/entities/memory.dart';
import '../../../memories/domain/entities/memory_photo.dart';

class MapMarkerGroup {
  const MapMarkerGroup({
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

  LatLng get coordinate => LatLng(latitude, longitude);

  int get count => memories.length;

  bool get isGroup => memories.length > 1;

  MemoryPhoto? get coverPhoto {
    for (final memory in memories) {
      final cover = memory.coverPhoto;
      if (cover != null) return cover;
    }
    return null;
  }

  MapMarkerGroup copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? locationName,
    String? address,
    List<Memory>? memories,
  }) {
    return MapMarkerGroup(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      address: address ?? this.address,
      memories: memories ?? this.memories,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapMarkerGroup &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          locationName == other.locationName &&
          address == other.address &&
          memories.length == other.memories.length;

  @override
  int get hashCode =>
      id.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      locationName.hashCode ^
      address.hashCode ^
      memories.length.hashCode;
}

