class MemoryLocation {
  const MemoryLocation({
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.source = 'manual',
    this.createdAt,
  });

  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String source;
  final DateTime? createdAt;

  bool get hasCoordinates => latitude != null && longitude != null;

  MemoryLocation copyWith({
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? source,
    DateTime? createdAt,
  }) {
    return MemoryLocation(
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryLocation &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          address == other.address &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          source == other.source;

  @override
  int get hashCode =>
      name.hashCode ^
      address.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      source.hashCode;

  @override
  String toString() =>
      'MemoryLocation(name: $name, address: $address, lat: $latitude, lon: $longitude, source: $source)';
}

