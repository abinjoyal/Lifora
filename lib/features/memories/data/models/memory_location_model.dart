import '../../domain/entities/memory_location.dart';

class MemoryLocationModel extends MemoryLocation {
  const MemoryLocationModel({
    required super.name,
    super.address,
    super.latitude,
    super.longitude,
    super.source = 'manual',
  });

  factory MemoryLocationModel.fromJson(Map<String, dynamic> json) {
    return MemoryLocationModel(
      name: json['name'] as String? ?? '',
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      source: json['source'] as String? ?? 'manual',
    );
  }

  factory MemoryLocationModel.fromEntity(MemoryLocation entity) {
    return MemoryLocationModel(
      name: entity.name,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      source: entity.source,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'source': source,
    };
  }
}
