class SetCoverPhoto {
  String? call({
    required String? currentCoverPhotoId,
    required String targetPhotoId,
  }) {
    if (currentCoverPhotoId == targetPhotoId) {
      return null;
    }
    return targetPhotoId;
  }
}

