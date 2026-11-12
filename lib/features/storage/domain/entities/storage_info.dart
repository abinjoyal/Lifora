class StorageInfo {
  StorageInfo({
    required this.folderName,
    required this.treeUri,
    this.pathDisplay,
    this.isWritable = true,
    this.memoryCount = 0,
    this.hasValidManifest = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String folderName;
  final String treeUri;
  final String? pathDisplay;
  final bool isWritable;
  final int memoryCount;
  final bool hasValidManifest;
  final DateTime createdAt;

  StorageInfo copyWith({
    String? folderName,
    String? treeUri,
    String? pathDisplay,
    bool? isWritable,
    int? memoryCount,
    bool? hasValidManifest,
    DateTime? createdAt,
  }) {
    return StorageInfo(
      folderName: folderName ?? this.folderName,
      treeUri: treeUri ?? this.treeUri,
      pathDisplay: pathDisplay ?? this.pathDisplay,
      isWritable: isWritable ?? this.isWritable,
      memoryCount: memoryCount ?? this.memoryCount,
      hasValidManifest: hasValidManifest ?? this.hasValidManifest,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StorageInfo &&
          runtimeType == other.runtimeType &&
          treeUri == other.treeUri &&
          folderName == other.folderName &&
          isWritable == other.isWritable;

  @override
  int get hashCode =>
      treeUri.hashCode ^ folderName.hashCode ^ isWritable.hashCode;

  @override
  String toString() =>
      'StorageInfo(folder: $folderName, uri: $treeUri, writable: $isWritable)';
}
