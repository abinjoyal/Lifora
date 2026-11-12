import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/map_marker_group.dart';

class MemoryMapMarkerWidget extends StatelessWidget {
  const MemoryMapMarkerWidget({
    super.key,
    required this.group,
    required this.isSelected,
    required this.onTap,
  });

  final MapMarkerGroup group;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _darkOrange = Color(0xFFB94E2D);
  static const Color _peach = Color(0xFFFFE2CC);

  @override
  Widget build(BuildContext context) {
    final cover = group.coverPhoto;
    final isGroup = group.isGroup;
    final count = group.count;

    final double size = isSelected ? 48.0 : 42.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Outer Pin Circle
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _primaryOrange,
                border: Border.all(
                  color: isSelected ? _darkOrange : Colors.white,
                  width: isSelected ? 3.0 : 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isSelected ? _darkOrange : Colors.black)
                        .withValues(alpha: isSelected ? 0.45 : 0.25),
                    blurRadius: isSelected ? 10.0 : 6.0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: cover?.localPath != null &&
                        File(cover!.localPath!).existsSync()
                    ? Image.file(
                        File(cover.localPath!),
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: _peach.withValues(alpha: 0.8),
                        child: Icon(
                          group.memories.first.category.icon,
                          size: isSelected ? 24.0 : 20.0,
                          color: _primaryOrange,
                        ),
                      ),
              ),
            ),

            // Multiple Memories Badge Pill
            if (isGroup)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: _darkOrange,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(minWidth: 18),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

