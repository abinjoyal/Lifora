import '../../domain/entities/storage_info.dart';

class StorageInfoModel extends StorageInfo {
  StorageInfoModel({
    required super.folderName,
    required super.treeUri,
    super.pathDisplay,
    super.isWritable = true,
    super.memoryCount = 0,
    super.hasValidManifest = true,
    super.createdAt,
  });

  factory StorageInfoModel.fromJson(Map<String, dynamic> json) {
    return StorageInfoModel(
      folderName: json['folderName'] as String? ?? 'Lifora Memories',
      treeUri: json['treeUri'] as String? ?? '',
      pathDisplay: json['pathDisplay'] as String?,
      isWritable: json['isWritable'] as bool? ?? true,
      memoryCount: json['memoryCount'] as int? ?? 0,
      hasValidManifest: json['hasValidManifest'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  factory StorageInfoModel.fromSafMap(
    Map<String, dynamic> map,
    String treeUri,
  ) {
    return StorageInfoModel(
      folderName: map['name'] as String? ?? 'Lifora Memories',
      treeUri: treeUri,
      pathDisplay: map['name'] as String?,
      isWritable: map['canWrite'] as bool? ?? true,
      memoryCount: 0,
      hasValidManifest: true,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folderName': folderName,
      'treeUri': treeUri,
      'pathDisplay': pathDisplay,
      'isWritable': isWritable,
      'memoryCount': memoryCount,
      'hasValidManifest': hasValidManifest,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
