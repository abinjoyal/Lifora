import '../entities/memory_location.dart';

abstract class LocationRepository {
  /// Checks whether GPS/location hardware services are enabled on device.
  Future<bool> isLocationServiceEnabled();

  /// Checks if location permission is granted.
  Future<bool> checkPermission();

  /// Requests location permission.
  Future<bool> requestPermission();

  /// Obtains current device GPS coordinates and resolves address if online.
  Future<MemoryLocation?> getCurrentLocation();

  /// Searches for places by keyword query with autocomplete/geocoding.
  Future<List<MemoryLocation>> searchPlaces(String query);

  /// Resolves human-readable address from coordinates (reverse geocoding).
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  );

  /// Resolves coordinates from place name or address (forward geocoding).
  Future<MemoryLocation?> getCoordinatesFromAddress(String address);

  /// Validates and saves a manually entered location.
  Future<MemoryLocation> saveManualLocation({
    required String name,
    String? address,
    double? latitude,
    double? longitude,
  });
}

