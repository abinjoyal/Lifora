import '../../../../shared/enums/memory_category.dart';
import '../../domain/entities/home_summary.dart';

class HomeMemoryItemModel extends HomeMemoryItem {
  const HomeMemoryItemModel({
    required super.id,
    required super.title,
    required super.date,
    super.category = MemoryCategory.personal,
    super.coverImagePath,
    super.locationName,
    super.isFavorite = false,
  });

  factory HomeMemoryItemModel.fromJson(Map<String, dynamic> json) {
    MemoryCategory cat = MemoryCategory.personal;
    final catStr = json['category'] as String?;
    if (catStr != null) {
      cat = MemoryCategory.values.firstWhere(
        (c) => c.name.toLowerCase() == catStr.toLowerCase(),
        orElse: () => MemoryCategory.personal,
      );
    }

    return HomeMemoryItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled Memory',
      date:
          DateTime.tryParse(json['date'] as String? ?? '')?.toLocal() ??
          DateTime.now(),
      category: cat,
      coverImagePath: json['coverImagePath'] as String?,
      locationName: json['locationName'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'category': category.name,
      'coverImagePath': coverImagePath,
      'locationName': locationName,
      'isFavorite': isFavorite,
    };
  }
}

class HomeSummaryModel extends HomeSummary {
  const HomeSummaryModel({
    required super.recentMemories,
    required super.totalMemories,
    required super.totalEvents,
    required super.totalTrips,
    super.hasStorageConnected = true,
  });

  factory HomeSummaryModel.fromMemoriesList({
    required List<HomeMemoryItem> memories,
    required bool hasStorage,
  }) {
    final sorted = List<HomeMemoryItem>.from(memories)
      ..sort((a, b) => b.date.compareTo(a.date));

    final int total = sorted.length;
    final int trips = sorted
        .where((m) => m.category == MemoryCategory.travel)
        .length;
    final int events = sorted
        .where(
          (m) =>
              m.category == MemoryCategory.celebration ||
              m.category == MemoryCategory.friends ||
              m.category == MemoryCategory.family,
        )
        .length;

    return HomeSummaryModel(
      recentMemories: sorted.take(5).toList(),
      totalMemories: total,
      totalEvents: events,
      totalTrips: trips,
      hasStorageConnected: hasStorage,
    );
  }
}
