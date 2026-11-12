import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/memory_location.dart';
import '../providers/location_search_provider.dart';
import '../widgets/location_empty_state.dart';
import '../widgets/location_picker_header.dart';
import '../widgets/location_search_bar.dart';
import '../widgets/location_suggestion_list.dart';

class LocationSearchPage extends ConsumerStatefulWidget {
  const LocationSearchPage({super.key});

  @override
  ConsumerState<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends ConsumerState<LocationSearchPage> {
  final _searchController = TextEditingController();

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(locationSearchProvider);
    final searchNotifier = ref.read(locationSearchProvider.notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        child: Column(
          children: [
            LocationPickerHeader(
              title: 'Search Places',
              onBack: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: LocationSearchBar(
                controller: _searchController,
                hintText: 'Search city, town, park or landmark...',
                onChanged: (val) => searchNotifier.onQueryChanged(val),
                onClear: () => searchNotifier.clear(),
              ),
            ),
            Expanded(
              child: _buildBody(searchState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LocationSearchState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_primaryOrange),
        ),
      );
    }

    if (state.errorMessage != null) {
      return LocationEmptyState(
        title: 'Search Unavailable',
        message: state.errorMessage!,
      );
    }

    if (state.query.trim().isNotEmpty && state.suggestions.isEmpty) {
      return LocationEmptyState(
        title: 'No Matching Places',
        message: 'No places found matching "${state.query}". Try a different name.',
      );
    }

    if (state.suggestions.isEmpty) {
      return const LocationEmptyState(
        title: 'Find Any Place',
        message: 'Search for cities, attractions, natural landmarks, or coffee shops.',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: LocationSuggestionList(
        suggestions: state.suggestions,
        onSelect: (MemoryLocation loc) {
          Navigator.pop(context, loc);
        },
      ),
    );
  }
}

