import '../entities/photo.dart';

class SelectPhotos {
  List<Photo> toggle({
    required List<Photo> currentSelection,
    required Photo photo,
    int maxLimit = 30,
  }) {
    final existingIndex =
        currentSelection.indexWhere((p) => p.id == photo.id);
    if (existingIndex >= 0) {
      final updated = List<Photo>.from(currentSelection)..removeAt(existingIndex);
      return updated;
    }

    if (currentSelection.length >= maxLimit) {
      return currentSelection;
    }

    return [...currentSelection, photo];
  }
}

