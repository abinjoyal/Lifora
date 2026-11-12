import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/storage_info.dart';
import '../../domain/repositories/storage_repository.dart';
import '../datasources/saf_storage_datasource.dart';
import '../datasources/storage_local_datasource.dart';
import '../datasources/storage_manifest_datasource.dart';
import '../datasources/storage_preferences_datasource.dart';
import '../models/storage_info_model.dart';

class StorageRepositoryImpl implements StorageRepository {
  StorageRepositoryImpl({
    required this.safDataSource,
    required this.preferencesDataSource,
    required this.manifestDataSource,
    required this.localDataSource,
  });

  final SafStorageDataSource safDataSource;
  final StoragePreferencesDataSource preferencesDataSource;
  final StorageManifestDataSource manifestDataSource;
  final StorageLocalDataSource localDataSource;

  @override
  Future<String?> selectParentFolder() async {
    final uri = await safDataSource.openDocumentTree();
    return uri;
  }

  @override
  Future<StorageInfo> createLiforaFolder(String parentTreeUri) async {
    // 1. Verify access to selected parent directory
    final accessMap = await safDataSource.checkFolderAccess(parentTreeUri);
    final bool canWrite = accessMap['canWrite'] as bool? ?? false;
    if (!canWrite) {
      throw const StorageException(
        'Selected parent directory is read-only or inaccessible.',
      );
    }

    // 2. Create dedicated "Lifora Memories" subfolder
    final String liforaFolderUri = await safDataSource.createDirectory(
      parentUri: parentTreeUri,
      name: 'Lifora Memories',
    );

    // 3. Initialize complete Lifora folder structure
    return initializeStorage(liforaFolderUri);
  }

  @override
  Future<StorageInfo?> selectExistingFolder() async {
    final treeUri = await safDataSource.openDocumentTree();
    if (treeUri == null || treeUri.isEmpty) return null;

    final accessMap = await safDataSource.checkFolderAccess(treeUri);
    final bool canWrite = accessMap['canWrite'] as bool? ?? false;
    if (!canWrite) {
      throw const StorageException(
        'Selected folder is read-only. Please grant write access.',
      );
    }

    // Check if the selected directory itself has an existing Lifora manifest
    final bool hasManifest = await manifestDataSource.hasValidManifest(treeUri);
    if (hasManifest) {
      // Reconnect immediately to existing Lifora folder
      return reconnectStorage(treeUri);
    }

    // Inspect if a "Lifora Memories" subfolder already exists inside it
    final children = await safDataSource.listFiles(treeUri);
    final liforaSubDir = children.firstWhere(
      (c) => c['name'] == 'Lifora Memories' && (c['isDirectory'] as bool),
      orElse: () => {},
    );

    if (liforaSubDir.isNotEmpty) {
      final subFolderUri = liforaSubDir['uri'] as String;
      final subHasManifest = await manifestDataSource.hasValidManifest(
        subFolderUri,
      );
      if (subHasManifest) {
        return reconnectStorage(subFolderUri);
      }
      return initializeStorage(subFolderUri);
    }

    // Otherwise, create "Lifora Memories" subfolder inside selected existing directory
    return createLiforaFolder(treeUri);
  }

  @override
  Future<StorageInfo> initializeStorage(String targetTreeUri) async {
    // 1. Create subfolders: Memories, Thumbnails, Exports
    await safDataSource.createDirectory(
      parentUri: targetTreeUri,
      name: 'Memories',
    );
    await safDataSource.createDirectory(
      parentUri: targetTreeUri,
      name: 'Thumbnails',
    );
    await safDataSource.createDirectory(
      parentUri: targetTreeUri,
      name: 'Exports',
    );

    // 2. Write initial manifest.json & settings.json
    final manifest = await manifestDataSource.createInitialManifest(
      targetTreeUri,
    );
    await manifestDataSource.createInitialSettings(targetTreeUri);

    // 3. Verify write access by writing and reading a safe probe file
    final isVerified = await verifyStorageAccess(targetTreeUri);
    if (!isVerified) {
      throw const StorageException(
        'Storage verification failed: folder is not writable.',
      );
    }

    // 4. Save persistent preferences
    await preferencesDataSource.saveTreeUri(targetTreeUri);
    await preferencesDataSource.setStorageSetupCompleted(true);

    final info = StorageInfoModel(
      folderName: 'Lifora Memories',
      treeUri: targetTreeUri,
      pathDisplay: 'Lifora Memories',
      isWritable: true,
      memoryCount: manifest.memoryCount,
      hasValidManifest: true,
      createdAt: manifest.createdAt,
    );

    localDataSource.cacheStorageInfo(info);
    return info;
  }

  @override
  Future<bool> verifyStorageAccess(String treeUri) async {
    try {
      final probeName = '.probe_${DateTime.now().millisecondsSinceEpoch}.tmp';
      final probeBytes = Uint8List.fromList(utf8.encode('lifora_verify'));

      final fileUri = await safDataSource.createFile(
        parentUri: treeUri,
        name: probeName,
        mimeType: 'text/plain',
        bytes: probeBytes,
      );

      final readBytes = await safDataSource.readBytesFromUri(fileUri);
      if (readBytes == null || utf8.decode(readBytes) != 'lifora_verify') {
        return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<StorageInfo> reconnectStorage(String treeUri) async {
    final manifest = await manifestDataSource.readManifest(treeUri);
    if (manifest == null) {
      throw const StorageException(
        'No valid Lifora manifest found in selected directory.',
      );
    }

    // Persist permissions
    await safDataSource.takePersistableUriPermission(treeUri);
    await preferencesDataSource.saveTreeUri(treeUri);
    await preferencesDataSource.setStorageSetupCompleted(true);

    final info = StorageInfoModel(
      folderName: 'Lifora Memories',
      treeUri: treeUri,
      pathDisplay: 'Lifora Memories',
      isWritable: true,
      memoryCount: manifest.memoryCount,
      hasValidManifest: true,
      createdAt: manifest.createdAt,
    );

    localDataSource.cacheStorageInfo(info);
    return info;
  }

  @override
  Future<StorageInfo?> getCurrentStorage() async {
    // Check in-memory cache first
    final cached = localDataSource.getCachedStorageInfo();
    if (cached != null) return cached;

    // Check saved preferences
    final savedUri = await preferencesDataSource.getSavedTreeUri();
    if (savedUri == null || savedUri.isEmpty) return null;

    final hasPerm = await safDataSource.hasUriPermission(savedUri);
    if (!hasPerm) return null;

    final manifest = await manifestDataSource.readManifest(savedUri);
    final info = StorageInfoModel(
      folderName: 'Lifora Memories',
      treeUri: savedUri,
      pathDisplay: 'Lifora Memories',
      isWritable: true,
      memoryCount: manifest?.memoryCount ?? 0,
      hasValidManifest: manifest != null,
      createdAt: manifest?.createdAt,
    );

    localDataSource.cacheStorageInfo(info);
    return info;
  }

  @override
  Future<void> disconnectStorage() async {
    final currentUri = await preferencesDataSource.getSavedTreeUri();
    if (currentUri != null && currentUri.isNotEmpty) {
      try {
        await safDataSource.releasePersistableUriPermission(currentUri);
      } catch (_) {}
    }
    await preferencesDataSource.clearStoragePreferences();
    localDataSource.clearCache();
  }
}
