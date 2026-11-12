import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/enums/memory_category.dart';
import '../../domain/entities/memory.dart';
import '../../domain/entities/memory_location.dart';
import '../../domain/entities/memory_photo.dart';
import 'memory_provider.dart';

class MemoryFormState {
  const MemoryFormState({
    required this.id,
    this.title = '',
    this.description = '',
    this.category = MemoryCategory.personal,
    required this.date,
    this.locationName = '',
    this.latitude,
    this.longitude,
    this.tags = const [],
    this.photos = const [],
    this.newPhotoPaths = const [],
    this.removedPhotoIds = const [],
    this.coverPhotoId,
    this.isFavorite = false,
    this.isSaving = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  final String id;
  final String title;
  final String description;
  final MemoryCategory category;
  final DateTime date;
  final String locationName;
  final double? latitude;
  final double? longitude;
  final List<String> tags;
  final List<MemoryPhoto> photos;
  final List<String> newPhotoPaths;
  final List<String> removedPhotoIds;
  final String? coverPhotoId;
  final bool isFavorite;
  final bool isSaving;
  final String? errorMessage;
  final bool isSuccess;

  MemoryFormState copyWith({
    String? id,
    String? title,
    String? description,
    MemoryCategory? category,
    DateTime? date,
    String? locationName,
    double? latitude,
    double? longitude,
    List<String>? tags,
    List<MemoryPhoto>? photos,
    List<String>? newPhotoPaths,
    List<String>? removedPhotoIds,
    String? coverPhotoId,
    bool? isFavorite,
    bool? isSaving,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return MemoryFormState(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      tags: tags ?? this.tags,
      photos: photos ?? this.photos,
      newPhotoPaths: newPhotoPaths ?? this.newPhotoPaths,
      removedPhotoIds: removedPhotoIds ?? this.removedPhotoIds,
      coverPhotoId: coverPhotoId ?? this.coverPhotoId,
      isFavorite: isFavorite ?? this.isFavorite,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class MemoryFormNotifier extends StateNotifier<MemoryFormState> {
  MemoryFormNotifier([Memory? initial])
    : super(
        MemoryFormState(
          id: initial?.id ?? 'mem_${DateTime.now().millisecondsSinceEpoch}',
          title: initial?.title ?? '',
          description: initial?.description ?? '',
          category: initial?.category ?? MemoryCategory.personal,
          date: initial?.date ?? DateTime.now(),
          locationName: initial?.location?.name ?? '',
          latitude: initial?.location?.latitude,
          longitude: initial?.location?.longitude,
          tags: initial?.tags ?? const [],
          photos: initial?.photos ?? const [],
          coverPhotoId: initial?.coverPhotoId,
          isFavorite: initial?.isFavorite ?? false,
        ),
      );

  void setTitle(String value) => state = state.copyWith(title: value);
  void setDescription(String value) =>
      state = state.copyWith(description: value);
  void setCategory(MemoryCategory category) =>
      state = state.copyWith(category: category);
  void setDate(DateTime date) => state = state.copyWith(date: date);

  void setLocation(String name, {double? lat, double? lon}) {
    state = state.copyWith(locationName: name, latitude: lat, longitude: lon);
  }

  void clearLocation() {
    state = state.copyWith(locationName: '', latitude: null, longitude: null);
  }

  void addPhotoPaths(List<String> paths) {
    final updated = List<String>.from(state.newPhotoPaths)..addAll(paths);
    state = state.copyWith(newPhotoPaths: updated);
  }

  void removePhoto({String? photoId, String? localPath}) {
    if (photoId != null) {
      final updatedPhotos = state.photos.where((p) => p.id != photoId).toList();
      final updatedRemoved = List<String>.from(state.removedPhotoIds)
        ..add(photoId);
      final coverId = state.coverPhotoId == photoId ? null : state.coverPhotoId;
      state = state.copyWith(
        photos: updatedPhotos,
        removedPhotoIds: updatedRemoved,
        coverPhotoId: coverId,
      );
    } else if (localPath != null) {
      final updated = List<String>.from(state.newPhotoPaths)..remove(localPath);
      state = state.copyWith(newPhotoPaths: updated);
    }
  }

  void setCoverPhotoId(String id) => state = state.copyWith(coverPhotoId: id);

  void addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isEmpty || state.tags.contains(trimmed)) return;
    state = state.copyWith(tags: [...state.tags, trimmed]);
  }

  void removeTag(String tag) {
    state = state.copyWith(tags: state.tags.where((t) => t != tag).toList());
  }

  void toggleFavorite() =>
      state = state.copyWith(isFavorite: !state.isFavorite);

  Future<bool> save(
    MemoryListNotifier listNotifier, {
    bool isEditing = false,
  }) async {
    if (state.title.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter a memory title.');
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final memory = Memory(
        id: state.id,
        title: state.title.trim(),
        description: state.description.trim().isEmpty
            ? null
            : state.description.trim(),
        category: state.category,
        date: state.date,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
        photos: state.photos,
        coverPhotoId: state.coverPhotoId,
        location: state.locationName.trim().isNotEmpty
            ? MemoryLocation(
                name: state.locationName.trim(),
                latitude: state.latitude,
                longitude: state.longitude,
              )
            : null,
        tags: state.tags,
        isFavorite: state.isFavorite,
      );

      if (isEditing) {
        await listNotifier.update(
          memory,
          newPhotoPaths: state.newPhotoPaths,
          removedPhotoIds: state.removedPhotoIds,
        );
      } else {
        await listNotifier.create(memory, newPhotoPaths: state.newPhotoPaths);
      }

      state = state.copyWith(isSaving: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }
}

final memoryFormProvider = StateNotifierProvider.autoDispose
    .family<MemoryFormNotifier, MemoryFormState, Memory?>((ref, initialMemory) {
      return MemoryFormNotifier(initialMemory);
    });
