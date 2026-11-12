import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/memory_location.dart';
import '../../domain/usecases/search_places.dart';
import 'location_provider.dart';

class LocationSearchState {
  const LocationSearchState({
    this.query = '',
    this.suggestions = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final String query;
  final List<MemoryLocation> suggestions;
  final bool isLoading;
  final String? errorMessage;

  LocationSearchState copyWith({
    String? query,
    List<MemoryLocation>? suggestions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LocationSearchState(
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LocationSearchNotifier extends StateNotifier<LocationSearchState> {
  LocationSearchNotifier(this._searchPlaces) : super(const LocationSearchState());

  final SearchPlaces _searchPlaces;
  Timer? _debounceTimer;

  void onQueryChanged(String query) {
    _debounceTimer?.cancel();
    state = state.copyWith(query: query);

    if (query.trim().isEmpty) {
      state = state.copyWith(suggestions: [], isLoading: false);
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      state = state.copyWith(isLoading: true, errorMessage: null);
      try {
        final results = await _searchPlaces(query);
        state = state.copyWith(suggestions: results, isLoading: false);
      } catch (e) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Unable to load place suggestions.',
        );
      }
    });
  }

  void clear() {
    _debounceTimer?.cancel();
    state = const LocationSearchState();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final locationSearchProvider =
    StateNotifierProvider.autoDispose<LocationSearchNotifier, LocationSearchState>(
        (ref) {
  return LocationSearchNotifier(ref.watch(searchPlacesUseCaseProvider));
});

