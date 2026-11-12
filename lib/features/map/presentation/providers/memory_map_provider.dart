import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../location/domain/usecases/get_current_location.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../../memories/presentation/providers/memory_provider.dart';
import '../../data/repositories/memory_map_repository_impl.dart';
import '../../domain/entities/map_filter.dart';
import '../../domain/entities/map_marker_group.dart';
import '../../domain/repositories/memory_map_repository.dart';
import '../../domain/usecases/get_memory_map_markers.dart';

final memoryMapRepositoryProvider = Provider<MemoryMapRepository>((ref) {
  final memoryRepo = ref.watch(memoryRepositoryProvider);
  return MemoryMapRepositoryImpl(memoryRepository: memoryRepo);
});

final getMemoryMapMarkersUseCaseProvider =
    Provider<GetMemoryMapMarkers>((ref) {
  final repo = ref.watch(memoryMapRepositoryProvider);
  return GetMemoryMapMarkers(repo);
});

class MemoryMapState {
  const MemoryMapState({
    this.markerGroups = const [],
    this.selectedMarkerGroup,
    this.filter = const MapFilter(),
    this.userLocation,
    this.isLoading = false,
    this.isLocatingUser = false,
    this.errorMessage,
    this.isTileOffline = false,
  });

  final List<MapMarkerGroup> markerGroups;
  final MapMarkerGroup? selectedMarkerGroup;
  final MapFilter filter;
  final LatLng? userLocation;
  final bool isLoading;
  final bool isLocatingUser;
  final String? errorMessage;
  final bool isTileOffline;

  int get totalMappedMemories =>
      markerGroups.fold<int>(0, (sum, g) => sum + g.count);

  bool get isEmpty => markerGroups.isEmpty && !isLoading;

  MemoryMapState copyWith({
    List<MapMarkerGroup>? markerGroups,
    MapMarkerGroup? selectedMarkerGroup,
    bool clearSelectedGroup = false,
    MapFilter? filter,
    LatLng? userLocation,
    bool? isLoading,
    bool? isLocatingUser,
    String? errorMessage,
    bool? isTileOffline,
  }) {
    return MemoryMapState(
      markerGroups: markerGroups ?? this.markerGroups,
      selectedMarkerGroup: clearSelectedGroup
          ? null
          : (selectedMarkerGroup ?? this.selectedMarkerGroup),
      filter: filter ?? this.filter,
      userLocation: userLocation ?? this.userLocation,
      isLoading: isLoading ?? this.isLoading,
      isLocatingUser: isLocatingUser ?? this.isLocatingUser,
      errorMessage: errorMessage,
      isTileOffline: isTileOffline ?? this.isTileOffline,
    );
  }
}

class MemoryMapNotifier extends StateNotifier<MemoryMapState> {
  MemoryMapNotifier({
    required this.getMemoryMapMarkers,
    required this.getCurrentLocation,
  }) : super(const MemoryMapState(isLoading: true)) {
    loadMarkers();
  }

  final GetMemoryMapMarkers getMemoryMapMarkers;
  final GetCurrentLocation getCurrentLocation;

  Future<void> loadMarkers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final groups = await getMemoryMapMarkers(filter: state.filter);

      // Preserve or clear selected group if no longer present in filtered groups
      MapMarkerGroup? newSelected;
      if (state.selectedMarkerGroup != null) {
        for (final g in groups) {
          if (g.id == state.selectedMarkerGroup!.id) {
            newSelected = g;
            break;
          }
        }
      }

      state = state.copyWith(
        markerGroups: groups,
        selectedMarkerGroup: newSelected,
        clearSelectedGroup: newSelected == null,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void selectMarkerGroup(MapMarkerGroup? group) {
    if (group == null) {
      state = state.copyWith(clearSelectedGroup: true);
    } else {
      state = state.copyWith(selectedMarkerGroup: group);
    }
  }

  void updateFilter(MapFilter filter) {
    state = state.copyWith(filter: filter);
    loadMarkers();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(
      filter: state.filter.copyWith(searchQuery: query),
    );
    loadMarkers();
  }

  void clearFilter() {
    state = state.copyWith(filter: const MapFilter());
    loadMarkers();
  }

  Future<LatLng?> locateUser() async {
    state = state.copyWith(isLocatingUser: true, errorMessage: null);

    try {
      final location = await getCurrentLocation();
      if (location != null && location.hasCoordinates) {
        final pos = LatLng(location.latitude!, location.longitude!);
        state = state.copyWith(
          userLocation: pos,
          isLocatingUser: false,
          errorMessage: null,
        );
        return pos;
      } else {
        state = state.copyWith(
          isLocatingUser: false,
          errorMessage: 'Unable to get current location. Ensure GPS is enabled.',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        isLocatingUser: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  void setTileOffline(bool isOffline) {
    state = state.copyWith(isTileOffline: isOffline);
  }
}

final memoryMapNotifierProvider =
    StateNotifierProvider<MemoryMapNotifier, MemoryMapState>((ref) {
  // Watch memoryListNotifierProvider so whenever memories change, map synchronizes!
  ref.watch(memoryListNotifierProvider);

  final getMarkers = ref.watch(getMemoryMapMarkersUseCaseProvider);
  final getGps = ref.watch(getCurrentLocationUseCaseProvider);

  return MemoryMapNotifier(
    getMemoryMapMarkers: getMarkers,
    getCurrentLocation: getGps,
  );
});

