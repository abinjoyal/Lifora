import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../location/data/datasources/location_map_datasource.dart';
import '../providers/memory_map_provider.dart';
import '../widgets/map_controls.dart';
import '../widgets/map_empty_state.dart';
import '../widgets/map_filter_sheet.dart';
import '../widgets/map_location_bottom_sheet.dart';
import '../widgets/map_search_bar.dart';
import '../widgets/memory_map_marker_widget.dart';

class MemoryMapPage extends ConsumerStatefulWidget {
  const MemoryMapPage({super.key});

  @override
  ConsumerState<MemoryMapPage> createState() => _MemoryMapPageState();
}

class _MemoryMapPageState extends ConsumerState<MemoryMapPage> {
  late final MapController _mapController;
  bool _didFitInitialBounds = false;

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _fitAllMarkers(List<LatLng> points) {
    if (points.isEmpty) return;

    if (points.length == 1) {
      _mapController.move(points.first, 14.0);
      return;
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLon = points.first.longitude;
    double maxLon = points.first.longitude;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLon) minLon = p.longitude;
      if (p.longitude > maxLon) maxLon = p.longitude;
    }

    final center = LatLng((minLat + maxLat) / 2, (minLon + maxLon) / 2);
    _mapController.move(center, 11.5);
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(memoryMapNotifierProvider);
    final mapNotifier = ref.read(memoryMapNotifierProvider.notifier);

    // Auto-fit bounds once when markers load
    if (!_didFitInitialBounds && mapState.markerGroups.isNotEmpty) {
      _didFitInitialBounds = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitAllMarkers(mapState.markerGroups.map((g) => g.coordinate).toList());
      });
    }

    final initialCenter = mapState.markerGroups.isNotEmpty
        ? mapState.markerGroups.first.coordinate
        : const LatLng(
            LocationMapDataSource.defaultLatitude,
            LocationMapDataSource.defaultLongitude,
          );

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. FlutterMap Core View
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: 12.0,
                onTap: (_, _) {
                  mapNotifier.selectMarkerGroup(null);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: LocationMapDataSource.tileUrlTemplate,
                  userAgentPackageName: LocationMapDataSource.userAgentPackageName,
                  errorTileCallback: (tile, error, stackTrace) {
                    mapNotifier.setTileOffline(true);
                  },
                ),

                // Marker Layer for Memory Groups
                MarkerLayer(
                  markers: [
                    // A. Memory Markers
                    for (final group in mapState.markerGroups)
                      Marker(
                        point: group.coordinate,
                        width: 52.0,
                        height: 52.0,
                        child: MemoryMapMarkerWidget(
                          group: group,
                          isSelected: mapState.selectedMarkerGroup?.id == group.id,
                          onTap: () {
                            mapNotifier.selectMarkerGroup(group);
                            _mapController.move(group.coordinate, 14.5);
                          },
                        ),
                      ),

                    // B. User GPS Location Marker (if available)
                    if (mapState.userLocation != null)
                      Marker(
                        point: mapState.userLocation!,
                        width: 32.0,
                        height: 32.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade900.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person_pin_circle_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),

            // 2. OpenStreetMap Attribution
            Positioned(
              bottom: mapState.selectedMarkerGroup != null ? 180.0 : 8.0,
              right: 8.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Text(
                  LocationMapDataSource.mapAttribution,
                  style: TextStyle(fontSize: 9.0, color: Colors.black54),
                ),
              ),
            ),

            // 3. Map Controls (Zoom, My Location, Fit All)
            Positioned(
              right: 16.0,
              bottom: mapState.selectedMarkerGroup != null ? 190.0 : 24.0,
              child: MapControls(
                isLocatingUser: mapState.isLocatingUser,
                onLocateUser: () async {
                  final target = await mapNotifier.locateUser();
                  if (target != null) {
                    _mapController.move(target, 15.0);
                  } else if (context.mounted && mapState.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(mapState.errorMessage!)),
                    );
                  }
                },
                onZoomIn: () {
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  );
                },
                onZoomOut: () {
                  _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  );
                },
                onFitAllMarkers: () {
                  _fitAllMarkers(
                    mapState.markerGroups.map((g) => g.coordinate).toList(),
                  );
                },
              ),
            ),

            // 4. Floating Top Search & Filter Bar
            Positioned(
              top: 8.0,
              left: 0,
              right: 0,
              child: MapSearchBar(
                initialQuery: mapState.filter.searchQuery,
                hasActiveFilters: mapState.filter.hasActiveFilters,
                onSearchChanged: (query) {
                  mapNotifier.setSearchQuery(query);
                },
                onFilterTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => MapFilterSheet(
                      initialFilter: mapState.filter,
                      onApply: (newFilter) {
                        mapNotifier.updateFilter(newFilter);
                      },
                    ),
                  );
                },
                onBack: () => Navigator.pop(context),
              ),
            ),

            // 5. Empty State (when no memories exist or match filter)
            if (mapState.isEmpty)
              Center(
                child: MapEmptyState(
                  hasActiveFilters: mapState.filter.hasActiveFilters,
                  onClearFilters: mapNotifier.clearFilter,
                  onAddMemory: () {
                    context.push(RouteConstants.createMemoryPath);
                  },
                ),
              ),

            // 6. Loading Indicator
            if (mapState.isLoading)
              const Positioned(
                top: 72.0,
                left: 0,
                right: 0,
                child: Center(
                  child: Card(
                    shape: StadiumBorder(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 6.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _primaryOrange,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Loading memories...',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // 7. Bottom Sheet for Selected Location
            if (mapState.selectedMarkerGroup != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MapLocationBottomSheet(
                  group: mapState.selectedMarkerGroup!,
                  onClose: () => mapNotifier.selectMarkerGroup(null),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

