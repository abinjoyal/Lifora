import 'package:flutter/material.dart';

enum PhotoSource {
  camera,
  gallery,
  file;

  String get displayName {
    return switch (this) {
      PhotoSource.camera => 'Take Photo',
      PhotoSource.gallery => 'Choose from Gallery',
      PhotoSource.file => 'Browse Files',
    };
  }

  IconData get icon {
    return switch (this) {
      PhotoSource.camera => Icons.camera_alt_outlined,
      PhotoSource.gallery => Icons.photo_library_outlined,
      PhotoSource.file => Icons.folder_open_outlined,
    };
  }
}
