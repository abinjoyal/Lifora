import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/memory_location.dart';
import '../../domain/usecases/select_location_on_map.dart';
import 'location_provider.dart';

class LocationMapState {
  const LocationMapState({
    required this.center,
    this.resolvedAddress,
    this.placeName = 'Pinned Location',
    this.isLoadingAddress = false,
  });

  final LatLng center;
  final String? resolvedAddress;
  final String placeName;
  final bool isLoadingAddress;

  LocationMapState copyWith({
    LatLng? center,
    String? resolvedAddress,
    String? placeName,
    bool? isLoadingAddress,
  }) {
    return LocationMapState(
      center: center ?? this.center,
      resolvedAddress: resolvedAddress ?? this.resolvedAddress,
      placeName: placeName ?? this.placeName,
      isLoadingAddress: isLoadingAddress ?? this.isLoadingAddress,
    );
  }
}

class LocationMapNotifier extends StateNotifier<LocationMapState> {
  LocationMapNotifier(this._selectLocationOnMap, {LatLng? initialCenter})
      : super(
          LocationMapState(
            center: initialCenter ?? const LatLng(20.5937, 78.9629),
          ),
        );

  final SelectLocationOnMap _selectLocationOnMap;
  Timer? _debounceTimer;

  void onMapCenterChanged(LatLng center) {
    _debounceTimer?.cancel();
    state = state.copyWith(center: center);

    _debounceTimer = Timer(const Duration(milliseconds: 600), () async {
      state = state.copyWith(isLoadingAddress: true);
      try {
        final loc = await _selectLocationOnMap(
          latitude: center.latitude,
          longitude: center.longitude,
        );
        state = state.copyWith(
          resolvedAddress: loc.address,
          placeName: loc.name,
          isLoadingAddress: false,
        );
      } catch (_) {
        state = state.copyWith(isLoadingAddress: false);
      }
    });
  }

  MemoryLocation buildLocation() {
    return MemoryLocation(
      name: state.placeName,
      address: state.resolvedAddress,
      latitude: state.center.latitude,
      longitude: state.center.longitude,
      source: 'map',
      createdAt: DateTime.now().toUtc(),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final locationMapProvider = StateNotifierProvider.autoDispose
    .family<LocationMapNotifier, LocationMapState, LatLng?>((ref, initial) {
  return LocationMapNotifier(
    ref.watch(selectLocationOnMapUseCaseProvider),
    initialCenter: initial,
  );
});

