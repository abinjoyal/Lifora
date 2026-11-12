class MemoryLocation {
  const MemoryLocation({
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.source = 'manual',
  });

  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String source;

  bool get hasCoordinates => latitude != null && longitude != null;

  MemoryLocation copyWith({
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    String? source,
  }) {
    return MemoryLocation(
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      source: source ?? this.source,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryLocation &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => name.hashCode ^ latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() =>
      'MemoryLocation(name: $name, lat: $latitude, lon: $longitude)';
}
