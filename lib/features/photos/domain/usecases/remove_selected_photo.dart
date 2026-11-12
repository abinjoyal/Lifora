import '../entities/photo.dart';

class RemoveSelectedPhoto {
  List<Photo> call({
    required List<Photo> currentSelection,
    required String photoId,
  }) {
    return currentSelection.where((p) => p.id != photoId).toList();
  }
}

