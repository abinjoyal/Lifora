import 'package:flutter/services.dart';
import '../../../../core/services/platform_channel_service.dart';

abstract class SafStorageDataSource {
  Future<String?> openDocumentTree();
  Future<bool> takePersistableUriPermission(String uri);
  Future<bool> hasUriPermission(String uri);
  Future<bool> releasePersistableUriPermission(String uri);
  Future<Map<String, dynamic>> checkFolderAccess(String folderUri);
  Future<String> createDirectory({
    required String parentUri,
    required String name,
  });
  Future<String> createFile({
    required String parentUri,
    required String name,
    String mimeType = 'application/octet-stream',
    Uint8List? bytes,
  });
  Future<bool> writeBytesToUri(String documentUri, Uint8List bytes);
  Future<Uint8List?> readBytesFromUri(String documentUri);
  Future<List<Map<String, dynamic>>> listFiles(String folderUri);
}

class SafStorageDataSourceImpl implements SafStorageDataSource {
  SafStorageDataSourceImpl({required this.platformChannelService});

  final PlatformChannelService platformChannelService;

  @override
  Future<String?> openDocumentTree() =>
      platformChannelService.openDocumentTree();

  @override
  Future<bool> takePersistableUriPermission(String uri) =>
      platformChannelService.takePersistableUriPermission(uri);

  @override
  Future<bool> hasUriPermission(String uri) =>
      platformChannelService.hasUriPermission(uri);

  @override
  Future<bool> releasePersistableUriPermission(String uri) =>
      platformChannelService.releasePersistableUriPermission(uri);

  @override
  Future<Map<String, dynamic>> checkFolderAccess(String folderUri) =>
      platformChannelService.checkFolderAccess(folderUri);

  @override
  Future<String> createDirectory({
    required String parentUri,
    required String name,
  }) =>
      platformChannelService.createDirectory(parentUri: parentUri, name: name);

  @override
  Future<String> createFile({
    required String parentUri,
    required String name,
    String mimeType = 'application/octet-stream',
    Uint8List? bytes,
  }) => platformChannelService.createFile(
    parentUri: parentUri,
    name: name,
    mimeType: mimeType,
    bytes: bytes,
  );

  @override
  Future<bool> writeBytesToUri(String documentUri, Uint8List bytes) =>
      platformChannelService.writeBytesToUri(documentUri, bytes);

  @override
  Future<Uint8List?> readBytesFromUri(String documentUri) =>
      platformChannelService.readBytesFromUri(documentUri);

  @override
  Future<List<Map<String, dynamic>>> listFiles(String folderUri) =>
      platformChannelService.listFiles(folderUri);
}
