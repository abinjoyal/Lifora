import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../shared/extensions/date_extensions.dart';
import '../../domain/entities/home_summary.dart';

class RecentMemoryCard extends StatelessWidget {
  const RecentMemoryCard({
    super.key,
    required this.memory,
    required this.onTap,
  });

  final HomeMemoryItem memory;
  final VoidCallback onTap;

  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 154.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Photo Image or Themed Placeholder
                if (memory.coverImagePath != null &&
                    File(memory.coverImagePath!).existsSync())
                  Image.file(File(memory.coverImagePath!), fit: BoxFit.cover)
                else
                  _buildPhotoPlaceholder(),

                // Bottom Dark Gradient Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 0.65, 1.0],
                      ),
                    ),
                  ),
                ),

                // Top Category Badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(
                      memory.category.icon,
                      size: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Bottom Text Content
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        memory.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        memory.date.toReadableDate(),
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFFFE2CC), const Color(0xFFFFD4B3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          memory.category.icon,
          size: 44,
          color: _primaryOrange.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
