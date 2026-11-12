import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/memory_location.dart';
import '../providers/location_provider.dart';
import '../widgets/current_location_card.dart';
import '../widgets/location_confirm_button.dart';
import '../widgets/location_details_card.dart';
import '../widgets/location_map_view.dart';
import '../widgets/location_permission_view.dart';
import '../widgets/location_picker_header.dart';
import '../widgets/location_search_bar.dart';
import '../widgets/manual_location_form.dart';
import 'location_map_page.dart';
import 'location_search_page.dart';

class LocationPickerPage extends ConsumerStatefulWidget {
  const LocationPickerPage({super.key, this.initialLocation});

  final MemoryLocation? initialLocation;

  @override
  ConsumerState<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends ConsumerState<LocationPickerPage> {
  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialLocation != null) {
        ref
            .read(locationNotifierProvider.notifier)
            .selectLocation(widget.initialLocation!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationNotifierProvider);
    final locationNotifier = ref.read(locationNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        child: Column(
          children: [
            LocationPickerHeader(
              title: 'Add Location',
              onBack: () => Navigator.pop(context),
              onSkip: () => Navigator.pop(context, null),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Search Bar (taps to open full search page)
                    LocationSearchBar(
                      readOnly: true,
                      onTap: () => _openSearch(context, locationNotifier),
                    ),
                    const SizedBox(height: 20.0),

                    // Error / Permission view if any
                    if (locationState.errorMessage != null) ...[
                      LocationPermissionView(
                        onRetry: () => locationNotifier.fetchGpsLocation(),
                        onOpenSettings: () {},
                      ),
                      const SizedBox(height: 20.0),
                    ],

                    // 2. Selected Location Preview Card (if active)
                    if (locationState.selectedLocation != null) ...[
                      LocationDetailsCard(
                        location: locationState.selectedLocation!,
                        onChangeLocation: () =>
                            locationNotifier.clearSelection(),
                        onClearLocation: () =>
                            locationNotifier.clearSelection(),
                      ),
                      const SizedBox(height: 20.0),
                    ],

                    // 3. Option A: Current GPS Location
                    const Text(
                      'Detect Position',
                      style: TextStyle(
                        color: _titleColor,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    CurrentLocationCard(
                      isLoading: locationState.isLoading,
                      currentLocation: locationState.currentGpsLocation,
                      onTap: () => locationNotifier.fetchGpsLocation(),
                    ),
                    const SizedBox(height: 24.0),

                    // 4. Option B: Pick on Map Preview
                    const Text(
                      'Choose on Map',
                      style: TextStyle(
                        color: _titleColor,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    _buildMapCard(context, locationState, locationNotifier),
                    const SizedBox(height: 24.0),

                    // 5. Option C: Manual Entry Form
                    ManualLocationForm(
                      initialLocation: locationState.selectedLocation,
                      onSaveLocation: (manualLoc) {
                        locationNotifier.selectLocation(manualLoc);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Set location to "${manualLoc.name}"'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),

            // Confirm Button (active if location selected)
            if (locationState.selectedLocation != null)
              LocationConfirmButton(
                onConfirm: () {
                  Navigator.pop(context, locationState.selectedLocation);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapCard(
    BuildContext context,
    LocationState state,
    LocationNotifier notifier,
  ) {
    final previewLat = state.selectedLocation?.latitude ?? 20.5937;
    final previewLon = state.selectedLocation?.longitude ?? 78.9629;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(15.0)),
            child: SizedBox(
              height: 140.0,
              child: AbsorbPointer(
                child: LocationMapView(
                  initialCenter: LatLng(previewLat, previewLon),
                  initialZoom: 12.0,
                  showCenterPin: true,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interactive Map',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.0,
                        color: _titleColor,
                      ),
                    ),
                    Text(
                      'Drag map to drop pin precisely',
                      style: TextStyle(color: Color(0xFF806A60), fontSize: 12.0),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE2CC),
                    foregroundColor: _primaryOrange,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () => _openMap(context, state, notifier),
                  icon: const Icon(Icons.map_rounded, size: 16),
                  label: const Text('Open Map'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openSearch(
    BuildContext context,
    LocationNotifier notifier,
  ) async {
    final result = await Navigator.push<MemoryLocation>(
      context,
      MaterialPageRoute(builder: (_) => const LocationSearchPage()),
    );
    if (result != null) {
      notifier.selectLocation(result);
    }
  }

  Future<void> _openMap(
    BuildContext context,
    LocationState state,
    LocationNotifier notifier,
  ) async {
    final result = await Navigator.push<MemoryLocation>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationMapPage(
          initialLocation: state.selectedLocation,
        ),
      ),
    );
    if (result != null) {
      notifier.selectLocation(result);
    }
  }
}

