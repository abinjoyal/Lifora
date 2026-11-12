import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/storage_constants.dart';
import '../models/storage_manifest_model.dart';
import 'saf_storage_datasource.dart';

abstract class StorageManifestDataSource {
  Future<StorageManifestModel> createInitialManifest(String folderUri);
  Future<StorageSettingsModel> createInitialSettings(String folderUri);
  Future<StorageManifestModel?> readManifest(String folderUri);
  Future<bool> hasValidManifest(String folderUri);
}

class StorageManifestDataSourceImpl implements StorageManifestDataSource {
  StorageManifestDataSourceImpl({required this.safDataSource});

  final SafStorageDataSource safDataSource;

  @override
  Future<StorageManifestModel> createInitialManifest(String folderUri) async {
    final manifest = StorageManifestModel.initial();
    final bytes = Uint8List.fromList(
      utf8.encode(manifest.toFormattedJsonString()),
    );

    await safDataSource.createFile(
      parentUri: folderUri,
      name: StorageConstants.manifestFileName,
      mimeType: 'application/json',
      bytes: bytes,
    );

    return manifest;
  }

  @override
  Future<StorageSettingsModel> createInitialSettings(String folderUri) async {
    final settings = StorageSettingsModel.initial();
    final bytes = Uint8List.fromList(
      utf8.encode(settings.toFormattedJsonString()),
    );

    await safDataSource.createFile(
      parentUri: folderUri,
      name: StorageConstants.appSettingsFileName,
      mimeType: 'application/json',
      bytes: bytes,
    );

    return settings;
  }

  @override
  Future<StorageManifestModel?> readManifest(String folderUri) async {
    try {
      final files = await safDataSource.listFiles(folderUri);
      final manifestEntry = files.firstWhere(
        (f) =>
            f['name'] == StorageConstants.manifestFileName &&
            !(f['isDirectory'] as bool),
        orElse: () => {},
      );

      if (manifestEntry.isEmpty) return null;

      final bytes = await safDataSource.readBytesFromUri(
        manifestEntry['uri'] as String,
      );
      if (bytes == null || bytes.isEmpty) return null;

      final jsonStr = utf8.decode(bytes);
      final jsonMap = json.decode(jsonStr) as Map<String, dynamic>;
      return StorageManifestModel.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> hasValidManifest(String folderUri) async {
    final manifest = await readManifest(folderUri);
    return manifest != null && manifest.formatVersion >= 1;
  }
}
