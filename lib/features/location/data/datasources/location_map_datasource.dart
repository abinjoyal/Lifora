class LocationMapDataSource {
  static const String tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const String userAgentPackageName = 'com.example.lifora';

  static const String mapAttribution = '© OpenStreetMap contributors';

  static const double defaultLatitude = 20.5937;
  static const double defaultLongitude = 78.9629;
  static const double defaultZoom = 13.0;
}

