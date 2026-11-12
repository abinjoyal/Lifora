import 'package:geolocator/geolocator.dart';
import '../../domain/entities/memory_location.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/save_manual_location.dart';
import '../datasources/location_geocoding_datasource.dart';
import '../datasources/location_gps_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl({
    required this.gpsDataSource,
    required this.geocodingDataSource,
  });

  final LocationGpsDataSource gpsDataSource;
  final LocationGeocodingDataSource geocodingDataSource;

  @override
  Future<bool> isLocationServiceEnabled() {
    return gpsDataSource.isLocationServiceEnabled();
  }

  @override
  Future<bool> checkPermission() async {
    final permission = await gpsDataSource.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> requestPermission() async {
    final permission = await gpsDataSource.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<MemoryLocation?> getCurrentLocation() async {
    final position = await gpsDataSource.getCurrentPosition();
    if (position == null) return null;

    final address = await geocodingDataSource.getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final name = address != null && address.contains(',')
        ? address.split(',').first.trim()
        : 'Current Location';

    return MemoryLocation(
      name: name,
      address: address,
      latitude: position.latitude,
      longitude: position.longitude,
      source: 'gps',
      createdAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<List<MemoryLocation>> searchPlaces(String query) {
    return geocodingDataSource.searchPlaces(query);
  }

  @override
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) {
    return geocodingDataSource.getAddressFromCoordinates(latitude, longitude);
  }

  @override
  Future<MemoryLocation?> getCoordinatesFromAddress(String address) {
    return geocodingDataSource.getCoordinatesFromAddress(address);
  }

  @override
  Future<MemoryLocation> saveManualLocation({
    required String name,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    return SaveManualLocation().call(
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

