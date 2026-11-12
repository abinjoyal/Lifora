import '../../../../shared/enums/memory_category.dart';
import 'memory_location.dart';
import 'memory_photo.dart';

class Memory {
  const Memory({
    required this.id,
    required this.title,
    this.description,
    this.category = MemoryCategory.personal,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.photos = const [],
    this.coverPhotoId,
    this.location,
    this.tags = const [],
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String? description;
  final MemoryCategory category;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MemoryPhoto> photos;
  final String? coverPhotoId;
  final MemoryLocation? location;
  final List<String> tags;
  final bool isFavorite;

  MemoryPhoto? get coverPhoto {
    if (photos.isEmpty) return null;
    if (coverPhotoId != null) {
      final found = photos.where((p) => p.id == coverPhotoId).firstOrNull;
      if (found != null) return found;
    }
    return photos.first;
  }

  Memory copyWith({
    String? id,
    String? title,
    String? description,
    MemoryCategory? category,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MemoryPhoto>? photos,
    String? coverPhotoId,
    MemoryLocation? location,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return Memory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photos: photos ?? this.photos,
      coverPhotoId: coverPhotoId ?? this.coverPhotoId,
      location: location ?? this.location,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Memory && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Memory(id: $id, title: $title, date: $date)';
}
