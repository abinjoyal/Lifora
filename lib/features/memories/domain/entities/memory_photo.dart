class MemoryPhoto {
  const MemoryPhoto({
    required this.id,
    required this.fileName,
    required this.originalFileName,
    this.mimeType = 'image/jpeg',
    required this.addedAt,
    this.checksum,
    this.localPath,
  });

  final String id;
  final String fileName;
  final String originalFileName;
  final String mimeType;
  final DateTime addedAt;
  final String? checksum;
  final String? localPath;

  MemoryPhoto copyWith({
    String? id,
    String? fileName,
    String? originalFileName,
    String? mimeType,
    DateTime? addedAt,
    String? checksum,
    String? localPath,
  }) {
    return MemoryPhoto(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      originalFileName: originalFileName ?? this.originalFileName,
      mimeType: mimeType ?? this.mimeType,
      addedAt: addedAt ?? this.addedAt,
      checksum: checksum ?? this.checksum,
      localPath: localPath ?? this.localPath,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryPhoto &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'MemoryPhoto(id: $id, file: $fileName)';
}
