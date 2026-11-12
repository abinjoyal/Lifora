import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/memory_location.dart';
import '../providers/location_map_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/location_confirm_button.dart';
import '../widgets/location_map_view.dart';
import '../widgets/location_picker_header.dart';

class LocationMapPage extends ConsumerStatefulWidget {
  const LocationMapPage({super.key, this.initialLocation});

  final MemoryLocation? initialLocation;

  @override
  ConsumerState<LocationMapPage> createState() => _LocationMapPageState();
}

class _LocationMapPageState extends ConsumerState<LocationMapPage> {
  late final MapController _mapController;
  late LatLng _currentCenter;

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentCenter = widget.initialLocation?.hasCoordinates ?? false
        ? LatLng(widget.initialLocation!.latitude!, widget.initialLocation!.longitude!)
        : const LatLng(20.5937, 78.9629);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(locationMapProvider(_currentCenter));
    final mapNotifier = ref.read(locationMapProvider(_currentCenter).notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Map
            Positioned.fill(
              child: LocationMapView(
                mapController: _mapController,
                initialCenter: _currentCenter,
                initialZoom: 14.0,
                onPositionChanged: (camera, hasGesture) {
                  if (hasGesture) {
                    mapNotifier.onMapCenterChanged(camera.center);
                  }
                },
              ),
            ),

            // Top Header Overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white.withValues(alpha: 0.9),
                child: LocationPickerHeader(
                  title: 'Choose on Map',
                  onBack: () => Navigator.pop(context),
                ),
              ),
            ),

            // Recenter GPS Button
            Positioned(
              right: 16.0,
              bottom: 180.0,
              child: FloatingActionButton.small(
                backgroundColor: Colors.white,
                foregroundColor: _primaryOrange,
                tooltip: 'My Location',
                onPressed: () => _centerOnGps(mapNotifier),
                child: const Icon(Icons.my_location_rounded),
              ),
            ),

            // Bottom Coordinates & Confirmation Card
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.pin_drop_rounded, color: _primaryOrange, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              mapState.placeName,
                              style: const TextStyle(
                                color: _titleColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          if (mapState.isLoadingAddress)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(_primaryOrange),
                              ),
                            ),
                        ],
                      ),
                      if (mapState.resolvedAddress != null) ...[
                        const SizedBox(height: 4.0),
                        Text(
                          mapState.resolvedAddress!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF806A60),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6.0),
                      Text(
                        '${mapState.center.latitude.toStringAsFixed(4)}°, ${mapState.center.longitude.toStringAsFixed(4)}°',
                        style: TextStyle(
                          color: _primaryOrange.withValues(alpha: 0.85),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      LocationConfirmButton(
                        onConfirm: () {
                          final selected = mapNotifier.buildLocation();
                          Navigator.pop(context, selected);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _centerOnGps(LocationMapNotifier mapNotifier) async {
    final getGps = ref.read(getCurrentLocationUseCaseProvider);
    final pos = await getGps();
    if (pos != null && pos.hasCoordinates) {
      final target = LatLng(pos.latitude!, pos.longitude!);
      _mapController.move(target, 15.0);
      mapNotifier.onMapCenterChanged(target);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not obtain current GPS position.')),
        );
      }
    }
  }
}

