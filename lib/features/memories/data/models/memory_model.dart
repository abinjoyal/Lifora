import 'dart:convert';
import '../../../../shared/enums/memory_category.dart';
import '../../domain/entities/memory.dart';
import 'memory_location_model.dart';
import 'memory_photo_model.dart';

class MemoryModel extends Memory {
  const MemoryModel({
    required super.id,
    required super.title,
    super.description,
    super.category = MemoryCategory.personal,
    required super.date,
    required super.createdAt,
    required super.updatedAt,
    super.photos = const [],
    super.coverPhotoId,
    super.location,
    super.tags = const [],
    super.isFavorite = false,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    MemoryCategory cat = MemoryCategory.personal;
    final catStr = json['category'] as String?;
    if (catStr != null) {
      cat = MemoryCategory.values.firstWhere(
        (c) => c.name.toLowerCase() == catStr.toLowerCase(),
        orElse: () => MemoryCategory.personal,
      );
    }

    final rawPhotos = json['photos'] as List<dynamic>? ?? [];
    final photosList = rawPhotos
        .map((p) => MemoryPhotoModel.fromJson(p as Map<String, dynamic>))
        .toList();

    MemoryLocationModel? loc;
    if (json['location'] != null && json['location'] is Map) {
      loc = MemoryLocationModel.fromJson(
        Map<String, dynamic>.from(json['location'] as Map),
      );
    }

    final rawTags = json['tags'] as List<dynamic>? ?? [];

    return MemoryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled Memory',
      description: json['description'] as String?,
      category: cat,
      date:
          DateTime.tryParse(json['date'] as String? ?? '')?.toLocal() ??
          DateTime.now(),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
      photos: photosList,
      coverPhotoId: json['coverPhotoId'] as String?,
      location: loc,
      tags: rawTags.map((e) => e.toString()).toList(),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  factory MemoryModel.fromEntity(Memory entity) {
    return MemoryModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      date: entity.date,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      photos: entity.photos.map((p) => MemoryPhotoModel.fromEntity(p)).toList(),
      coverPhotoId: entity.coverPhotoId,
      location: entity.location != null
          ? MemoryLocationModel.fromEntity(entity.location!)
          : null,
      tags: entity.tags,
      isFavorite: entity.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'photos': photos
          .map(
            (p) => (p is MemoryPhotoModel ? p : MemoryPhotoModel.fromEntity(p))
                .toJson(),
          )
          .toList(),
      'coverPhotoId': coverPhotoId,
      'location': location != null
          ? (location is MemoryLocationModel
                ? (location! as MemoryLocationModel).toJson()
                : MemoryLocationModel.fromEntity(location!).toJson())
          : null,
      'tags': tags,
      'isFavorite': isFavorite,
    };
  }

  /// Compact mapping for root manifest.json index
  Map<String, dynamic> toManifestMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'category': category.name,
      'coverImagePath': coverPhoto?.localPath ?? coverPhoto?.fileName,
      'locationName': location?.name,
      'photoCount': photos.length,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toFormattedJsonString() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(toJson());
  }
}
