import '../../domain/entities/photo.dart';

class PhotoModel extends Photo {
  const PhotoModel({
    required super.id,
    required super.path,
    required super.name,
    super.albumId,
    super.albumName,
    required super.dateAdded,
    super.size = 0,
    super.mimeType = 'image/jpeg',
    super.width,
    super.height,
  });

  factory PhotoModel.fromMap(Map<String, dynamic> map) {
    final dateRaw = map['dateAdded'];
    DateTime date;
    if (dateRaw is int) {
      date = DateTime.fromMillisecondsSinceEpoch(dateRaw);
    } else if (dateRaw is String) {
      date = DateTime.tryParse(dateRaw) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    return PhotoModel(
      id: map['id']?.toString() ?? '',
      path: map['path']?.toString() ?? '',
      name: map['name']?.toString() ?? 'photo.jpg',
      albumId: map['albumId']?.toString(),
      albumName: map['albumName']?.toString(),
      dateAdded: date,
      size: (map['size'] as num?)?.toInt() ?? 0,
      mimeType: map['mimeType']?.toString() ?? 'image/jpeg',
      width: (map['width'] as num?)?.toInt(),
      height: (map['height'] as num?)?.toInt(),
    );
  }

  factory PhotoModel.fromEntity(Photo entity) {
    return PhotoModel(
      id: entity.id,
      path: entity.path,
      name: entity.name,
      albumId: entity.albumId,
      albumName: entity.albumName,
      dateAdded: entity.dateAdded,
      size: entity.size,
      mimeType: entity.mimeType,
      width: entity.width,
      height: entity.height,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'albumId': albumId,
      'albumName': albumName,
      'dateAdded': dateAdded.millisecondsSinceEpoch,
      'size': size,
      'mimeType': mimeType,
      'width': width,
      'height': height,
    };
  }
}

