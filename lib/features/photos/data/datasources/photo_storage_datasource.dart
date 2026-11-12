import 'dart:io';
import 'dart:typed_data';
import 'package:lifora/features/memories/data/models/memory_photo_model.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/services/platform_channel_service.dart';
import '../../../../core/utils/file_utils.dart';
import '../../../../core/utils/image_utils.dart';
import '../../../storage/data/datasources/saf_storage_datasource.dart';
import '../../../storage/data/datasources/storage_preferences_datasource.dart';

abstract class PhotoStorageDataSource {
  Future<List<MemoryPhotoModel>> importPhotosToMemory({
    required String memoryId,
    required int year,
    required List<String> sourcePaths,
    String? coverSourcePath,
  });
}

class PhotoStorageDataSourceImpl implements PhotoStorageDataSource {
  PhotoStorageDataSourceImpl({
    required this.safDataSource,
    required this.preferencesDataSource,
    required this.platformChannelService,
  });

  final SafStorageDataSource safDataSource;
  final StoragePreferencesDataSource preferencesDataSource;
  final PlatformChannelService platformChannelService;

  @override
  Future<List<MemoryPhotoModel>> importPhotosToMemory({
    required String memoryId,
    required int year,
    required List<String> sourcePaths,
    String? coverSourcePath,
  }) async {
    final rootUri = await preferencesDataSource.getSavedTreeUri();
    if (rootUri == null) {
      throw Exception('Lifora storage folder is not configured.');
    }

    // 1. Ensure Memories directory exists
    final memoriesDirUri = await safDataSource.createDirectory(
      parentUri: rootUri,
      name: StorageConstants.memoriesFolder,
    );

    // 2. Ensure Year directory exists
    final yearDirUri = await safDataSource.createDirectory(
      parentUri: memoriesDirUri,
      name: year.toString(),
    );

    // 3. Ensure Memory-specific directory exists
    final memoryDirUri = await safDataSource.createDirectory(
      parentUri: yearDirUri,
      name: memoryId,
    );

    // 4. Ensure Thumbnails directory exists
    final thumbnailsDirUri = await safDataSource.createDirectory(
      parentUri: rootUri,
      name: StorageConstants.thumbnailsFolder,
    );

    final List<MemoryPhotoModel> importedPhotos = [];

    for (int i = 0; i < sourcePaths.length; i++) {
      final src = sourcePaths[i];
      final isCover = src == coverSourcePath;
      final ext = FileUtils.getExtension(src);
      final cleanExt = ext.isNotEmpty ? '.$ext' : '.jpg';
      final photoId = 'photo_${DateTime.now().millisecondsSinceEpoch}_$i';
      final fileName = isCover
          ? 'cover$cleanExt'
          : 'photo_${(i + 1).toString().padLeft(3, '0')}$cleanExt';

      Uint8List? bytes;
      if (src.startsWith('content://')) {
        try {
          bytes = await platformChannelService.readBytesFromUri(src);
        } catch (_) {}
      } else {
        final f = File(src);
        if (await f.exists()) {
          bytes = await f.readAsBytes();
        }
      }

      final originalName = src.contains('/') ? src.split('/').last : src;

      if (bytes == null || bytes.isEmpty) {
        // Fallback: If unreadable as bytes, retain original path
        importedPhotos.add(
          MemoryPhotoModel(
            id: photoId,
            fileName: fileName,
            originalFileName: originalName,
            addedAt: DateTime.now().toUtc(),
            localPath: src,
          ),
        );
        continue;
      }

      // Write full photo file to SAF memory folder
      final destFileUri = await safDataSource.createFile(
        parentUri: memoryDirUri,
        name: fileName,
        mimeType: 'image/jpeg',
        bytes: bytes,
      );

      // Write thumbnail to SAF thumbnails folder
      final thumbName =
          ImageUtils.getThumbnailFileName('${photoId}_$fileName');
      try {
        await safDataSource.createFile(
          parentUri: thumbnailsDirUri,
          name: thumbName,
          mimeType: 'image/webp',
          bytes: bytes,
        );
      } catch (_) {}

      importedPhotos.add(
        MemoryPhotoModel(
          id: photoId,
          fileName: fileName,
          originalFileName: originalName,
          addedAt: DateTime.now().toUtc(),
          localPath: destFileUri,
        ),
      );
    }

    return importedPhotos;
  }
}
