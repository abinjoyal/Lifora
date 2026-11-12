import '../../../../shared/enums/memory_category.dart';

class HomeMemoryItem {
  const HomeMemoryItem({
    required this.id,
    required this.title,
    required this.date,
    this.category = MemoryCategory.personal,
    this.coverImagePath,
    this.locationName,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final DateTime date;
  final MemoryCategory category;
  final String? coverImagePath;
  final String? locationName;
  final bool isFavorite;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeMemoryItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          date == other.date;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ date.hashCode;
}

class HomeSummary {
  const HomeSummary({
    required this.recentMemories,
    required this.totalMemories,
    required this.totalEvents,
    required this.totalTrips,
    this.hasStorageConnected = true,
  });

  final List<HomeMemoryItem> recentMemories;
  final int totalMemories;
  final int totalEvents;
  final int totalTrips;
  final bool hasStorageConnected;

  static const HomeSummary empty = HomeSummary(
    recentMemories: [],
    totalMemories: 0,
    totalEvents: 0,
    totalTrips: 0,
    hasStorageConnected: false,
  );
}
