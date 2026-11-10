import 'dart:math';

class FileUtils {
  FileUtils._();

  static const List<String> supportedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];
  static const List<String> supportedAudioExtensions = [
    'm4a',
    'aac',
    'mp3',
    'wav',
    'ogg',
  ];

  /// Sanitizes string to create a safe filesystem filename.
  /// Removes invalid characters such as /, \, :, *, ?, ", <, >, |.
  static String sanitizeFileName(String input) {
    final sanitized = input
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .trim();

    return sanitized.isEmpty ? 'untitled' : sanitized;
  }

  /// Generates a unique, timestamped filename for a memory media item.
  static String generateMediaFileName({
    required String prefix,
    required String extension,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomSuffix = Random().nextInt(10000).toString().padLeft(4, '0');
    final cleanExtension = extension.startsWith('.')
        ? extension
        : '.$extension';
    return '${sanitizeFileName(prefix)}_${timestamp}_$randomSuffix$cleanExtension';
  }

  /// Extracts file extension without leading dot (lowercase).
  static String getExtension(String path) {
    if (!path.contains('.')) return '';
    return path.split('.').last.toLowerCase().trim();
  }

  /// Validates whether a file extension is a supported image type.
  static bool isSupportedImage(String path) {
    final ext = getExtension(path);
    return supportedImageExtensions.contains(ext);
  }

  /// Validates whether a file extension is a supported audio type.
  static bool isSupportedAudio(String path) {
    final ext = getExtension(path);
    return supportedAudioExtensions.contains(ext);
  }

  /// Formats byte count into human-readable representation: "12.4 MB"
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(bytes) / log(1024)).floor();
    final clampedIndex = i.clamp(0, suffixes.length - 1);
    final size = bytes / pow(1024, clampedIndex);
    return '${size.toStringAsFixed(clampedIndex == 0 ? 0 : 1)} ${suffixes[clampedIndex]}';
  }
}
