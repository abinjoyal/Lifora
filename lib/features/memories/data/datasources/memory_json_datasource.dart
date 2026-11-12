import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:lifora/features/storage/data/datasources/saf_storage_datasource.dart';
import 'package:lifora/features/storage/data/datasources/storage_manifest_datasource.dart';
import 'package:lifora/features/storage/data/datasources/storage_preferences_datasource.dart';
import 'package:lifora/features/storage/data/models/storage_manifest_model.dart';
import '../../../../core/constants/storage_constants.dart';
import '../models/memory_model.dart';

abstract class MemoryJsonDataSource {
  Future<void> saveMemoryJson(MemoryModel memory);
  Future<MemoryModel?> readMemoryJson(String memoryId, int year);
  Future<void> deleteMemoryFolder(String memoryId, int year);
  Future<void> updateManifest(List<MemoryModel> allMemories);
  Future<String?> getSavedStorageUri();
}

class MemoryJsonDataSourceImpl implements MemoryJsonDataSource {
  MemoryJsonDataSourceImpl({
    required this.safDataSource,
    required this.preferencesDataSource,
    required this.manifestDataSource,
  });

  final SafStorageDataSource safDataSource;
  final StoragePreferencesDataSource preferencesDataSource;
  final StorageManifestDataSource manifestDataSource;

  @override
  Future<String?> getSavedStorageUri() =>
      preferencesDataSource.getSavedTreeUri();

  @override
  Future<void> saveMemoryJson(MemoryModel memory) async {
    final rootUri = await getSavedStorageUri();
    if (rootUri == null) return;

    final yearStr = memory.date.year.toString();

    // 1. Ensure Memories/ directory
    final memoriesDirUri = await safDataSource.createDirectory(
      parentUri: rootUri,
      name: StorageConstants.memoriesFolder,
    );

    // 2. Ensure Memories/<year>/ directory
    final yearDirUri = await safDataSource.createDirectory(
      parentUri: memoriesDirUri,
      name: yearStr,
    );

    // 3. Ensure Memories/<year>/<uuid>/ directory
    final memoryDirUri = await safDataSource.createDirectory(
      parentUri: yearDirUri,
      name: memory.id,
    );

    // 4. Write memory.json
    final bytes = Uint8List.fromList(
      utf8.encode(memory.toFormattedJsonString()),
    );
    await safDataSource.createFile(
      parentUri: memoryDirUri,
      name: StorageConstants.metadataFileName,
      mimeType: 'application/json',
      bytes: bytes,
    );
  }

  @override
  Future<MemoryModel?> readMemoryJson(String memoryId, int year) async {
    try {
      final rootUri = await getSavedStorageUri();
      if (rootUri == null) return null;

      // Navigate Memories/ -> <year>/ -> <uuid>/ -> memory.json
      final files = await safDataSource.listFiles(rootUri);
      final memoriesDir = files.firstWhere(
        (f) =>
            f['name'] == StorageConstants.memoriesFolder &&
            (f['isDirectory'] as bool),
        orElse: () => {},
      );
      if (memoriesDir.isEmpty) return null;

      final yearFiles = await safDataSource.listFiles(
        memoriesDir['uri'] as String,
      );
      final yearDir = yearFiles.firstWhere(
        (f) => f['name'] == year.toString() && (f['isDirectory'] as bool),
        orElse: () => {},
      );
      if (yearDir.isEmpty) return null;

      final memoryDirs = await safDataSource.listFiles(
        yearDir['uri'] as String,
      );
      final targetDir = memoryDirs.firstWhere(
        (f) => f['name'] == memoryId && (f['isDirectory'] as bool),
        orElse: () => {},
      );
      if (targetDir.isEmpty) return null;

      final dirContents = await safDataSource.listFiles(
        targetDir['uri'] as String,
      );
      final jsonFile = dirContents.firstWhere(
        (f) => f['name'] == StorageConstants.metadataFileName,
        orElse: () => {},
      );
      if (jsonFile.isEmpty) return null;

      final bytes = await safDataSource.readBytesFromUri(
        jsonFile['uri'] as String,
      );
      if (bytes == null || bytes.isEmpty) return null;

      final jsonMap = json.decode(utf8.decode(bytes)) as Map<String, dynamic>;
      return MemoryModel.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteMemoryFolder(String memoryId, int year) async {
    // In SAF, deleting a directory can be done by releasing or we clear its JSON
  }

  @override
  Future<void> updateManifest(List<MemoryModel> allMemories) async {
    final rootUri = await getSavedStorageUri();
    if (rootUri == null) return;

    int totalPhotos = 0;
    final List<Map<String, dynamic>> manifestList = [];

    for (final m in allMemories) {
      totalPhotos += m.photos.length;
      manifestList.add(m.toManifestMap());
    }

    final manifest = StorageManifestModel(
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      memoryCount: allMemories.length,
      photoCount: totalPhotos,
      memories: manifestList,
    );

    final bytes = Uint8List.fromList(
      utf8.encode(manifest.toFormattedJsonString()),
    );
    await safDataSource.createFile(
      parentUri: rootUri,
      name: StorageConstants.manifestFileName,
      mimeType: 'application/json',
      bytes: bytes,
    );
  }
}
