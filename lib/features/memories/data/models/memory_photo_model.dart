import '../../domain/entities/memory_photo.dart';

class MemoryPhotoModel extends MemoryPhoto {
  const MemoryPhotoModel({
    required super.id,
    required super.fileName,
    required super.originalFileName,
    super.mimeType = 'image/jpeg',
    required super.addedAt,
    super.checksum,
    super.localPath,
  });

  factory MemoryPhotoModel.fromJson(Map<String, dynamic> json) {
    return MemoryPhotoModel(
      id: json['id'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      originalFileName: json['originalFileName'] as String? ?? '',
      mimeType: json['mimeType'] as String? ?? 'image/jpeg',
      addedAt:
          DateTime.tryParse(json['addedAt'] as String? ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
      checksum: json['checksum'] as String?,
      localPath: json['localPath'] as String?,
    );
  }

  factory MemoryPhotoModel.fromEntity(MemoryPhoto entity) {
    return MemoryPhotoModel(
      id: entity.id,
      fileName: entity.fileName,
      originalFileName: entity.originalFileName,
      mimeType: entity.mimeType,
      addedAt: entity.addedAt,
      checksum: entity.checksum,
      localPath: entity.localPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'originalFileName': originalFileName,
      'mimeType': mimeType,
      'addedAt': addedAt.toIso8601String(),
      'checksum': checksum,
      'localPath': localPath,
    };
  }
}
