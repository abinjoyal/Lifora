import '../entities/memory_location.dart';

class SaveManualLocation {
  MemoryLocation call({
    required String name,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      throw ArgumentError('Place name is required.');
    }

    if (latitude != null) {
      if (latitude < -90.0 || latitude > 90.0) {
        throw ArgumentError('Latitude must be between -90 and 90 degrees.');
      }
    }

    if (longitude != null) {
      if (longitude < -180.0 || longitude > 180.0) {
        throw ArgumentError('Longitude must be between -180 and 180 degrees.');
      }
    }

    return MemoryLocation(
      name: cleanName,
      address: address?.trim().isEmpty ?? true ? null : address!.trim(),
      latitude: latitude,
      longitude: longitude,
      source: 'manual',
      createdAt: DateTime.now().toUtc(),
    );
  }
}

