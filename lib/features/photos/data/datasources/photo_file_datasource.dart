import 'dart:io';
import 'dart:typed_data';

abstract class PhotoFileDataSource {
  Future<bool> fileExists(String path);
  Future<Uint8List?> readFileBytes(String path);
  Future<int> getFileSize(String path);
}

class PhotoFileDataSourceImpl implements PhotoFileDataSource {
  @override
  Future<bool> fileExists(String path) async {
    try {
      if (path.startsWith('content://')) {
        return true;
      }
      return File(path).exists();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Uint8List?> readFileBytes(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<int> getFileSize(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }
}

