import '../entities/memory_location.dart';
import '../repositories/location_repository.dart';

class SelectLocationOnMap {
  SelectLocationOnMap(this._repository);

  final LocationRepository _repository;

  Future<MemoryLocation> call({
    required double latitude,
    required double longitude,
    String? placeName,
  }) async {
    final address =
        await _repository.getAddressFromCoordinates(latitude, longitude);
    final name = placeName ??
        (address != null && address.contains(',')
            ? address.split(',').first.trim()
            : 'Pinned Location');

    return MemoryLocation(
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      source: 'map',
      createdAt: DateTime.now().toUtc(),
    );
  }
}

