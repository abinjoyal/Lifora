import 'package:lifora/features/storage/data/datasources/storage_manifest_datasource.dart';
import 'package:lifora/features/storage/data/datasources/storage_preferences_datasource.dart';
import '../models/home_summary_model.dart';

abstract class HomeLocalDataSource {
  Future<HomeSummaryModel> getHomeSummary();
  Future<List<HomeMemoryItemModel>> getRecentMemories({int limit = 5});
  Future<Map<String, int>> getMemoryStatistics();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  HomeLocalDataSourceImpl({
    required this.preferencesDataSource,
    required this.manifestDataSource,
  });

  final StoragePreferencesDataSource preferencesDataSource;
  final StorageManifestDataSource manifestDataSource;

  @override
  Future<HomeSummaryModel> getHomeSummary() async {
    final uri = await preferencesDataSource.getSavedTreeUri();
    if (uri == null || uri.isEmpty) {
      return HomeSummaryModel.fromMemoriesList(memories: [], hasStorage: false);
    }

    final manifest = await manifestDataSource.readManifest(uri);
    if (manifest == null) {
      return HomeSummaryModel.fromMemoriesList(memories: [], hasStorage: true);
    }

    final List<HomeMemoryItemModel> memoryItems = manifest.memories
        .map((m) => HomeMemoryItemModel.fromJson(m))
        .toList();

    return HomeSummaryModel.fromMemoriesList(
      memories: memoryItems,
      hasStorage: true,
    );
  }

  @override
  Future<List<HomeMemoryItemModel>> getRecentMemories({int limit = 5}) async {
    final summary = await getHomeSummary();
    return summary.recentMemories
        .map((e) => e as HomeMemoryItemModel)
        .take(limit)
        .toList();
  }

  @override
  Future<Map<String, int>> getMemoryStatistics() async {
    final summary = await getHomeSummary();
    return {
      'total': summary.totalMemories,
      'events': summary.totalEvents,
      'trips': summary.totalTrips,
    };
  }
}
