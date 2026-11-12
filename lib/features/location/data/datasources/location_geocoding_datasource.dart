import 'dart:convert';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import '../models/location_model.dart';

abstract class LocationGeocodingDataSource {
  Future<String?> getAddressFromCoordinates(double latitude, double longitude);
  Future<LocationModel?> getCoordinatesFromAddress(String address);
  Future<List<LocationModel>> searchPlaces(String query);
}

class LocationGeocodingDataSourceImpl implements LocationGeocodingDataSource {
  static const String _nominatimBaseUrl =
      'https://nominatim.openstreetmap.org/search';

  @override
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          if (p.name != null && p.name!.isNotEmpty) p.name,
          if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality,
          if (p.locality != null && p.locality!.isNotEmpty) p.locality,
          if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty)
            p.administrativeArea,
          if (p.country != null && p.country!.isNotEmpty) p.country,
        ];
        return parts.toSet().join(', ');
      }
    } catch (_) {}

    // Fallback coordinate representation
    return 'Lat: ${latitude.toStringAsFixed(4)}, Lon: ${longitude.toStringAsFixed(4)}';
  }

  @override
  Future<LocationModel?> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        return LocationModel(
          name: address,
          address: address,
          latitude: loc.latitude,
          longitude: loc.longitude,
          source: 'search',
        );
      }
    } catch (_) {}

    // Fallback: search via Nominatim
    final results = await searchPlaces(address);
    return results.isNotEmpty ? results.first : null;
  }

  @override
  Future<List<LocationModel>> searchPlaces(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    try {
      // 1. Try local native geocoding first
      try {
        final nativeLocations = await locationFromAddress(trimmed);
        if (nativeLocations.isNotEmpty) {
          final results = <LocationModel>[];
          for (final loc in nativeLocations.take(5)) {
            final addr = await getAddressFromCoordinates(
              loc.latitude,
              loc.longitude,
            );
            results.add(
              LocationModel(
                name: trimmed,
                address: addr,
                latitude: loc.latitude,
                longitude: loc.longitude,
                source: 'search',
              ),
            );
          }
          if (results.isNotEmpty) return results;
        }
      } catch (_) {}

      // 2. HTTP Geocoding via Nominatim with User-Agent
      final uri = Uri.parse(
        '$_nominatimBaseUrl?q=${Uri.encodeComponent(trimmed)}&format=json&addressdetails=1&limit=8',
      );

      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 8);
      final request = await client.getUrl(uri);
      request.headers.set('User-Agent', 'Lifora-Journal/1.0 (Android)');
      request.headers.set('Accept', 'application/json');

      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final List<dynamic> data = jsonDecode(responseBody) as List<dynamic>;

        final List<LocationModel> items = [];
        for (final item in data) {
          final map = item as Map<String, dynamic>;
          final displayName = map['display_name'] as String? ?? trimmed;
          final lat = double.tryParse(map['lat']?.toString() ?? '');
          final lon = double.tryParse(map['lon']?.toString() ?? '');

          final name = displayName.contains(',')
              ? displayName.split(',').first.trim()
              : displayName;

          items.add(
            LocationModel(
              name: name,
              address: displayName,
              latitude: lat,
              longitude: lon,
              source: 'search',
              createdAt: DateTime.now().toUtc(),
            ),
          );
        }
        return items;
      }
    } catch (_) {}

    return [];
  }
}

