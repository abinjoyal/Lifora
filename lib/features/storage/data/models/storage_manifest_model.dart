import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/storage_constants.dart';

class StorageManifestModel {
  const StorageManifestModel({
    this.appName = AppConstants.appName,
    this.formatVersion = StorageConstants.storageFormatVersion,
    required this.createdAt,
    required this.updatedAt,
    this.memoryCount = 0,
    this.photoCount = 0,
    this.memories = const [],
  });

  final String appName;
  final int formatVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int memoryCount;
  final int photoCount;
  final List<Map<String, dynamic>> memories;

  factory StorageManifestModel.initial() {
    final now = DateTime.now().toUtc();
    return StorageManifestModel(
      createdAt: now,
      updatedAt: now,
      memoryCount: 0,
      photoCount: 0,
      memories: const [],
    );
  }

  factory StorageManifestModel.fromJson(Map<String, dynamic> json) {
    return StorageManifestModel(
      appName: json['appName'] as String? ?? AppConstants.appName,
      formatVersion:
          json['formatVersion'] as int? ??
          StorageConstants.storageFormatVersion,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
      memoryCount: json['memoryCount'] as int? ?? 0,
      photoCount: json['photoCount'] as int? ?? 0,
      memories:
          (json['memories'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'formatVersion': formatVersion,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'memoryCount': memoryCount,
      'photoCount': photoCount,
      'memories': memories,
    };
  }

  String toFormattedJsonString() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(toJson());
  }
}

class StorageSettingsModel {
  const StorageSettingsModel({
    this.schemaVersion = StorageConstants.storageFormatVersion,
    this.appName = AppConstants.appName,
    this.storageInitialized = true,
    required this.createdAt,
  });

  final int schemaVersion;
  final String appName;
  final bool storageInitialized;
  final DateTime createdAt;

  factory StorageSettingsModel.initial() {
    return StorageSettingsModel(createdAt: DateTime.now().toUtc());
  }

  factory StorageSettingsModel.fromJson(Map<String, dynamic> json) {
    return StorageSettingsModel(
      schemaVersion:
          json['schemaVersion'] as int? ??
          StorageConstants.storageFormatVersion,
      appName: json['appName'] as String? ?? AppConstants.appName,
      storageInitialized: json['storageInitialized'] as bool? ?? true,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'appName': appName,
      'storageInitialized': storageInitialized,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String toFormattedJsonString() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(toJson());
  }
}
