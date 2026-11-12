import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../shared/enums/memory_category.dart';

class MemoryCoverImage extends StatelessWidget {
  const MemoryCoverImage({
    super.key,
    this.imagePath,
    this.category = MemoryCategory.personal,
  });

  final String? imagePath;
  final MemoryCategory category;

  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && File(imagePath!).existsSync()) {
      return AspectRatio(
        aspectRatio: 16 / 10,
        child: Image.file(File(imagePath!), fit: BoxFit.cover),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Container(
        color: const Color(0xFFFFE2CC),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 56, color: _primaryOrange),
              const SizedBox(height: 8),
              Text(
                category.displayName,
                style: const TextStyle(
                  color: Color(0xFFB94E2D),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
