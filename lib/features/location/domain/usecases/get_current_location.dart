import '../entities/memory_location.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocation {
  GetCurrentLocation(this._repository);

  final LocationRepository _repository;

  Future<MemoryLocation?> call() {
    return _repository.getCurrentLocation();
  }
}

