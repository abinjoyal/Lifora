import '../entities/memory_location.dart';
import '../repositories/location_repository.dart';

class GetCoordinatesFromAddress {
  GetCoordinatesFromAddress(this._repository);

  final LocationRepository _repository;

  Future<MemoryLocation?> call(String address) {
    return _repository.getCoordinatesFromAddress(address);
  }
}

