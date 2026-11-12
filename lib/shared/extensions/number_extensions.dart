import '../../core/utils/file_utils.dart';

extension NumberExtensions on num {
  /// Converts numeric byte count into readable file size ("2.4 MB").
  String toFileSize() => FileUtils.formatFileSize(toInt());

  /// Formats number into compact representation (e.g., 1.5K, 2.3M).
  String toCompactCount() {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }

  /// Formats milliseconds into duration string (e.g., "02:45").
  String toMinuteSeconds() {
    final int totalSeconds = (this / 1000).round();
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
