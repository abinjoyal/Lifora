import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/location_geocoding_datasource.dart';
import '../../data/datasources/location_gps_datasource.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/entities/memory_location.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_address_from_coordinates.dart';
import '../../domain/usecases/get_coordinates_from_address.dart';
import '../../domain/usecases/get_current_location.dart';
import '../../domain/usecases/save_manual_location.dart';
import '../../domain/usecases/search_places.dart';
import '../../domain/usecases/select_location_on_map.dart';

// Data Sources
final locationGpsDataSourceProvider = Provider<LocationGpsDataSource>((ref) {
  return LocationGpsDataSourceImpl();
});

final locationGeocodingDataSourceProvider =
    Provider<LocationGeocodingDataSource>((ref) {
  return LocationGeocodingDataSourceImpl();
});

// Repository
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl(
    gpsDataSource: ref.watch(locationGpsDataSourceProvider),
    geocodingDataSource: ref.watch(locationGeocodingDataSourceProvider),
  );
});

// Use Cases
final getCurrentLocationUseCaseProvider = Provider<GetCurrentLocation>((ref) {
  return GetCurrentLocation(ref.watch(locationRepositoryProvider));
});

final searchPlacesUseCaseProvider = Provider<SearchPlaces>((ref) {
  return SearchPlaces(ref.watch(locationRepositoryProvider));
});

final getAddressFromCoordinatesUseCaseProvider =
    Provider<GetAddressFromCoordinates>((ref) {
  return GetAddressFromCoordinates(ref.watch(locationRepositoryProvider));
});

final getCoordinatesFromAddressUseCaseProvider =
    Provider<GetCoordinatesFromAddress>((ref) {
  return GetCoordinatesFromAddress(ref.watch(locationRepositoryProvider));
});

final selectLocationOnMapUseCaseProvider = Provider<SelectLocationOnMap>((ref) {
  return SelectLocationOnMap(ref.watch(locationRepositoryProvider));
});

final saveManualLocationUseCaseProvider = Provider<SaveManualLocation>((ref) {
  return SaveManualLocation();
});

// State
class LocationState {
  const LocationState({
    this.selectedLocation,
    this.currentGpsLocation,
    this.isLoading = false,
    this.errorMessage,
  });

  final MemoryLocation? selectedLocation;
  final MemoryLocation? currentGpsLocation;
  final bool isLoading;
  final String? errorMessage;

  LocationState copyWith({
    MemoryLocation? selectedLocation,
    MemoryLocation? currentGpsLocation,
    bool? isLoading,
    String? errorMessage,
    bool clearSelected = false,
    bool clearError = false,
  }) {
    return LocationState(
      selectedLocation:
          clearSelected ? null : (selectedLocation ?? this.selectedLocation),
      currentGpsLocation: currentGpsLocation ?? this.currentGpsLocation,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier(this._getCurrentLocation) : super(const LocationState());

  final GetCurrentLocation _getCurrentLocation;

  Future<void> fetchGpsLocation() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final loc = await _getCurrentLocation();
      if (loc != null) {
        state = state.copyWith(
          isLoading: false,
          currentGpsLocation: loc,
          selectedLocation: loc,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Could not get GPS location. Please check permissions and enable location services.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error detecting location: $e',
      );
    }
  }

  void selectLocation(MemoryLocation location) {
    state = state.copyWith(
      selectedLocation: location,
      clearError: true,
    );
  }

  void clearSelection() {
    state = state.copyWith(clearSelected: true, clearError: true);
  }
}

final locationNotifierProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier(ref.watch(getCurrentLocationUseCaseProvider));
});

