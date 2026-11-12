import '../../domain/entities/photo_album.dart';

class PhotoAlbumModel extends PhotoAlbum {
  const PhotoAlbumModel({
    required super.id,
    required super.name,
    super.photoCount = 0,
    super.coverPhotoPath,
  });

  factory PhotoAlbumModel.fromMap(Map<String, dynamic> map) {
    return PhotoAlbumModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Gallery',
      photoCount: (map['photoCount'] as num?)?.toInt() ?? 0,
      coverPhotoPath: map['coverPhotoPath']?.toString(),
    );
  }

  factory PhotoAlbumModel.fromEntity(PhotoAlbum entity) {
    return PhotoAlbumModel(
      id: entity.id,
      name: entity.name,
      photoCount: entity.photoCount,
      coverPhotoPath: entity.coverPhotoPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoCount': photoCount,
      'coverPhotoPath': coverPhotoPath,
    };
  }
}

