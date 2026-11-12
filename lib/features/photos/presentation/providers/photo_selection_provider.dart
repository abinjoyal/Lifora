import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/photo.dart';

class PhotoSelectionState {
  const PhotoSelectionState({
    this.selectedPhotos = const [],
    this.coverPhotoId,
    this.maxLimit = 30,
    this.statusMessage,
  });

  final List<Photo> selectedPhotos;
  final String? coverPhotoId;
  final int maxLimit;
  final String? statusMessage;

  int get count => selectedPhotos.length;
  bool get isEmpty => selectedPhotos.isEmpty;
  bool get isNotEmpty => selectedPhotos.isNotEmpty;
  bool get isMaxReached => selectedPhotos.length >= maxLimit;

  bool isSelected(String photoId) => selectedPhotos.any((p) => p.id == photoId);

  int selectionIndex(String photoId) {
    final idx = selectedPhotos.indexWhere((p) => p.id == photoId);
    return idx >= 0 ? idx + 1 : 0;
  }

  bool isCover(String photoId) {
    if (coverPhotoId != null) return coverPhotoId == photoId;
    return selectedPhotos.isNotEmpty && selectedPhotos.first.id == photoId;
  }

  PhotoSelectionState copyWith({
    List<Photo>? selectedPhotos,
    String? coverPhotoId,
    int? maxLimit,
    String? statusMessage,
    bool clearStatusMessage = false,
  }) {
    return PhotoSelectionState(
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      coverPhotoId: coverPhotoId ?? this.coverPhotoId,
      maxLimit: maxLimit ?? this.maxLimit,
      statusMessage:
          clearStatusMessage ? null : (statusMessage ?? this.statusMessage),
    );
  }
}

class PhotoSelectionNotifier extends StateNotifier<PhotoSelectionState> {
  PhotoSelectionNotifier() : super(const PhotoSelectionState());

  void togglePhoto(Photo photo) {
    final isAlreadySelected =
        state.selectedPhotos.any((p) => p.id == photo.id);

    if (isAlreadySelected) {
      final updated =
          state.selectedPhotos.where((p) => p.id != photo.id).toList();
      final coverId =
          state.coverPhotoId == photo.id ? null : state.coverPhotoId;
      state = state.copyWith(
        selectedPhotos: updated,
        coverPhotoId: coverId,
        clearStatusMessage: true,
      );
    } else {
      if (state.isMaxReached) {
        state = state.copyWith(
          statusMessage: 'Maximum limit of ${state.maxLimit} photos reached.',
        );
        return;
      }
      final updated = [...state.selectedPhotos, photo];
      state = state.copyWith(
        selectedPhotos: updated,
        coverPhotoId: state.coverPhotoId ?? photo.id,
        clearStatusMessage: true,
      );
    }
  }

  void removePhoto(String photoId) {
    final updated =
        state.selectedPhotos.where((p) => p.id != photoId).toList();
    final coverId =
        state.coverPhotoId == photoId ? null : state.coverPhotoId;
    state = state.copyWith(
      selectedPhotos: updated,
      coverPhotoId: coverId,
      clearStatusMessage: true,
    );
  }

  void setCoverPhoto(String photoId) {
    state = state.copyWith(
      coverPhotoId: photoId,
      clearStatusMessage: true,
    );
  }

  void addRawPaths(List<String> paths) {
    final List<Photo> newPhotos = [];
    for (int i = 0; i < paths.length; i++) {
      final path = paths[i];
      if (state.selectedPhotos.any((p) => p.path == path)) continue;
      if (state.selectedPhotos.length + newPhotos.length >= state.maxLimit) break;

      final id = 'picked_${DateTime.now().millisecondsSinceEpoch}_$i';
      newPhotos.add(
        Photo(
          id: id,
          path: path,
          name: 'photo_$id.jpg',
          dateAdded: DateTime.now(),
        ),
      );
    }
    if (newPhotos.isNotEmpty) {
      final updated = [...state.selectedPhotos, ...newPhotos];
      state = state.copyWith(
        selectedPhotos: updated,
        coverPhotoId: state.coverPhotoId ?? updated.first.id,
        clearStatusMessage: true,
      );
    }
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final items = List<Photo>.from(state.selectedPhotos);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = state.copyWith(selectedPhotos: items);
  }

  void clear() {
    state = const PhotoSelectionState();
  }
}

final photoSelectionProvider =
    StateNotifierProvider<PhotoSelectionNotifier, PhotoSelectionState>((ref) {
  return PhotoSelectionNotifier();
});

