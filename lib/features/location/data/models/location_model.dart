import '../../domain/entities/memory_location.dart';

class LocationModel extends MemoryLocation {
  const LocationModel({
    required super.name,
    super.address,
    super.latitude,
    super.longitude,
    super.source = 'manual',
    super.createdAt,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] as String? ?? 'Unnamed Place',
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      source: json['source'] as String? ?? 'manual',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)?.toUtc()
          : null,
    );
  }

  factory LocationModel.fromEntity(MemoryLocation entity) {
    return LocationModel(
      name: entity.name,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      source: entity.source,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'source': source,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}

