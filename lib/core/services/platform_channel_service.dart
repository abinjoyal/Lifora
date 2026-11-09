import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../errors/app_exception.dart';

class PlatformChannelService {
  PlatformChannelService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.lifora.app/saf');

  final MethodChannel _channel;

  /// Launches the Android Storage Access Framework (SAF) folder picker
  /// allowing user to choose a directory for Lifora memories.
  /// Returns the persistent Tree URI string or null if canceled by user.
  Future<String?> openDocumentTree() async {
    try {
      final String? treeUri = await _channel.invokeMethod<String>(
        'openDocumentTree',
      );
      return treeUri;
    } on PlatformException catch (e) {
      throw StorageException(
        e.message ?? 'Failed to open directory tree via SAF.',
        e,
      );
    } catch (e) {
      throw StorageException('Unexpected error during folder selection.', e);
    }
  }

  /// Takes persistable URI permission so Lifora retains read/write access
  /// to the selected folder even after device reboot.
  Future<bool> takePersistableUriPermission(String uri) async {
    try {
      final bool? success = await _channel.invokeMethod<bool>(
        'takePersistableUriPermission',
        {'uri': uri},
      );
      return success ?? false;
    } on PlatformException catch (e) {
      throw StorageException(
        e.message ?? 'Failed to take persistable URI permission.',
        e,
        uri,
      );
    }
  }

  /// Verifies if Lifora currently has valid persistable permissions for the given URI.
  Future<bool> hasUriPermission(String uri) async {
    try {
      final bool? hasPermission = await _channel.invokeMethod<bool>(
        'hasUriPermission',
        {'uri': uri},
      );
      return hasPermission ?? false;
    } on PlatformException catch (e) {
      throw StorageException(
        e.message ?? 'Failed to check URI permission.',
        e,
        uri,
      );
    }
  }

  /// Releases persistent URI permission if user resets storage configuration.
  Future<bool> releasePersistableUriPermission(String uri) async {
    try {
      final bool? released = await _channel.invokeMethod<bool>(
        'releasePersistableUriPermission',
        {'uri': uri},
      );
      return released ?? false;
    } on PlatformException catch (e) {
      throw StorageException(
        e.message ?? 'Failed to release persistable URI permission.',
        e,
        uri,
      );
    }
  }

  /// Writes data directly to an SAF document URI.
  Future<bool> writeBytesToUri(String documentUri, Uint8List bytes) async {
    try {
      final bool? result = await _channel.invokeMethod<bool>(
        'writeBytesToUri',
        {'uri': documentUri, 'bytes': bytes},
      );
      return result ?? false;
    } on PlatformException catch (e) {
      throw FileOperationException(
        e.message ?? 'Failed to write bytes to document URI.',
        e,
        documentUri,
      );
    }
  }

  /// Reads bytes directly from an SAF document URI.
  Future<Uint8List?> readBytesFromUri(String documentUri) async {
    try {
      final Uint8List? bytes = await _channel.invokeMethod<Uint8List>(
        'readBytesFromUri',
        {'uri': documentUri},
      );
      return bytes;
    } on PlatformException catch (e) {
      throw FileOperationException(
        e.message ?? 'Failed to read bytes from document URI.',
        e,
        documentUri,
      );
    }
  }

  /// Checks read/write accessibility for a folder tree URI.
  Future<Map<String, dynamic>> checkFolderAccess(String folderUri) async {
    try {
      final Map<dynamic, dynamic>? result = await _channel
          .invokeMethod<Map<dynamic, dynamic>>('checkFolderAccess', {
            'uri': folderUri,
          });
      if (result == null) {
        return {'exists': false, 'canRead': false, 'canWrite': false};
      }
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      throw StorageException(
        e.message ?? 'Failed to check folder access.',
        e,
        folderUri,
      );
    }
  }

  /// Creates a directory inside a parent folder tree.
  Future<String> createDirectory({
    required String parentUri,
    required String name,
  }) async {
    try {
      final String? dirUri = await _channel.invokeMethod<String>(
        'createDirectory',
        {'parentUri': parentUri, 'name': name},
      );
      if (dirUri == null) {
        throw StorageException(
          'Failed to create directory $name',
          null,
          parentUri,
        );
      }
      return dirUri;
    } on PlatformException catch (e) {
      throw StorageException(
        e.message ?? 'Directory creation failed.',
        e,
        parentUri,
      );
    }
  }

  /// Creates a document file inside a directory with optional initial byte content.
  Future<String> createFile({
    required String parentUri,
    required String name,
    String mimeType = 'application/octet-stream',
    Uint8List? bytes,
  }) async {
    try {
      final String? fileUri = await _channel.invokeMethod<String>(
        'createFile',
        {
          'parentUri': parentUri,
          'name': name,
          'mimeType': mimeType,
          'bytes': bytes,
        },
      );
      if (fileUri == null) {
        throw FileOperationException(
          'Failed to create document $name',
          null,
          parentUri,
        );
      }
      return fileUri;
    } on PlatformException catch (e) {
      throw FileOperationException(
        e.message ?? 'File creation failed.',
        e,
        parentUri,
      );
    }
  }

  /// Lists children files and subdirectories of a given folder.
  Future<List<Map<String, dynamic>>> listFiles(String folderUri) async {
    try {
      final List<dynamic>? rawList = await _channel.invokeMethod<List<dynamic>>(
        'listFiles',
        {'folderUri': folderUri},
      );
      if (rawList == null) return [];
      return rawList
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } on PlatformException catch (e) {
      throw StorageException(
        e.message ?? 'Failed to list directory contents.',
        e,
        folderUri,
      );
    }
  }
}

final platformChannelServiceProvider = Provider<PlatformChannelService>((ref) {
  return PlatformChannelService();
});
