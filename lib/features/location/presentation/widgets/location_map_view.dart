import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/datasources/location_map_datasource.dart';
import 'location_marker.dart';

class LocationMapView extends StatelessWidget {
  const LocationMapView({
    super.key,
    required this.initialCenter,
    this.initialZoom = 14.0,
    this.onPositionChanged,
    this.mapController,
    this.showCenterPin = true,
  });

  final LatLng initialCenter;
  final double initialZoom;
  final void Function(MapCamera camera, bool hasGesture)? onPositionChanged;
  final MapController? mapController;
  final bool showCenterPin;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: initialZoom,
            onPositionChanged: onPositionChanged,
          ),
          children: [
            TileLayer(
              urlTemplate: LocationMapDataSource.tileUrlTemplate,
              userAgentPackageName: LocationMapDataSource.userAgentPackageName,
              errorTileCallback: (_, _, _) {
                // Graceful fallback for offline map tiles
              },
            ),
          ],
        ),

        // Fixed Center Marker Pin
        if (showCenterPin)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 36.0),
              child: LocationMarker(),
            ),
          ),

        // Attribution in Bottom Right
        Positioned(
          bottom: 4.0,
          right: 6.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: const Text(
              LocationMapDataSource.mapAttribution,
              style: TextStyle(
                fontSize: 9.0,
                color: Color(0xFF806A60),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

