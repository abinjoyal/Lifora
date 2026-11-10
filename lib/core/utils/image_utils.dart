import 'dart:math';
import 'package:flutter/material.dart';
import 'file_utils.dart';

class ImageUtils {
  ImageUtils._();

  static const double defaultThumbnailDimension = 300.0;

  /// Validates if an image path has a valid image extension.
  static bool isValidImagePath(String path) {
    return FileUtils.isSupportedImage(path);
  }

  /// Calculates proportional dimensions that fit within maximum bounds
  /// while preserving aspect ratio.
  static Size calculateAspectFitSize({
    required double originalWidth,
    required double originalHeight,
    double maxWidth = defaultThumbnailDimension,
    double maxHeight = defaultThumbnailDimension,
  }) {
    if (originalWidth <= 0 || originalHeight <= 0) {
      return Size(maxWidth, maxHeight);
    }

    final double widthRatio = maxWidth / originalWidth;
    final double heightRatio = maxHeight / originalHeight;
    final double scale = min(widthRatio, heightRatio);

    return Size(
      (originalWidth * scale).roundToDouble(),
      (originalHeight * scale).roundToDouble(),
    );
  }

  /// Computes optimal memory image cache dimensions for Flutter Image widgets.
  static int computeCacheSize(double displayWidth, double devicePixelRatio) {
    return (displayWidth * devicePixelRatio).round();
  }

  /// Generates a thumbnail filename corresponding to a parent image filename.
  static String getThumbnailFileName(String originalFileName) {
    final cleanName = originalFileName.contains('.')
        ? originalFileName.substring(0, originalFileName.lastIndexOf('.'))
        : originalFileName;
    return 'thumb_$cleanName.webp';
  }
}
