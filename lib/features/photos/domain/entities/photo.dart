class Photo {
  const Photo({
    required this.id,
    required this.path,
    required this.name,
    this.albumId,
    this.albumName,
    required this.dateAdded,
    this.size = 0,
    this.mimeType = 'image/jpeg',
    this.width,
    this.height,
  });

  final String id;
  final String path;
  final String name;
  final String? albumId;
  final String? albumName;
  final DateTime dateAdded;
  final int size;
  final String mimeType;
  final int? width;
  final int? height;

  Photo copyWith({
    String? id,
    String? path,
    String? name,
    String? albumId,
    String? albumName,
    DateTime? dateAdded,
    int? size,
    String? mimeType,
    int? width,
    int? height,
  }) {
    return Photo(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      albumId: albumId ?? this.albumId,
      albumName: albumName ?? this.albumName,
      dateAdded: dateAdded ?? this.dateAdded,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Photo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Photo(id: $id, name: $name, path: $path)';
}

