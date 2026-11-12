import '../entities/home_summary.dart';

abstract class HomeRepository {
  /// Loads comprehensive home summary including recent memories and category statistics.
  Future<HomeSummary> getHomeSummary();

  /// Loads the most recent N memories ordered chronologically.
  Future<List<HomeMemoryItem>> getRecentMemories({int limit = 5});

  /// Computes statistics map: 'total', 'events', 'trips'.
  Future<Map<String, int>> getMemoryStatistics();
}
