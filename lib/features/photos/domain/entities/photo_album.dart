class PhotoAlbum {
  const PhotoAlbum({
    required this.id,
    required this.name,
    this.photoCount = 0,
    this.coverPhotoPath,
  });

  final String id;
  final String name;
  final int photoCount;
  final String? coverPhotoPath;

  PhotoAlbum copyWith({
    String? id,
    String? name,
    int? photoCount,
    String? coverPhotoPath,
  }) {
    return PhotoAlbum(
      id: id ?? this.id,
      name: name ?? this.name,
      photoCount: photoCount ?? this.photoCount,
      coverPhotoPath: coverPhotoPath ?? this.coverPhotoPath,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoAlbum && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PhotoAlbum(id: $id, name: $name, count: $photoCount)';
}

