import '../repositories/location_repository.dart';

class GetAddressFromCoordinates {
  GetAddressFromCoordinates(this._repository);

  final LocationRepository _repository;

  Future<String?> call(double latitude, double longitude) {
    return _repository.getAddressFromCoordinates(latitude, longitude);
  }
}

