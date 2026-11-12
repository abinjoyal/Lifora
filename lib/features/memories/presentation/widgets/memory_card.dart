import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/memory.dart';
import 'memory_date_badge.dart';

class MemoryCard extends StatelessWidget {
  const MemoryCard({
    super.key,
    required this.memory,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Memory memory;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    final cover = memory.coverPhoto;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38251F).withValues(alpha: 0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Cover Image Stack
                AspectRatio(
                  aspectRatio: 1.15,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (cover?.localPath != null &&
                          File(cover!.localPath!).existsSync())
                        Image.file(File(cover.localPath!), fit: BoxFit.cover)
                      else
                        _buildPlaceholder(),

                      // Top Category Badge
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7.0,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            memory.category.icon,
                            size: 13.0,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Favorite Heart Button
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: Icon(
                            memory.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                            size: 20.0,
                            color: memory.isFavorite
                                ? const Color(0xFFE91E63)
                                : Colors.white,
                          ),
                          onPressed: onToggleFavorite,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Content
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memory.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _titleColor,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      MemoryDateBadge(date: memory.date),
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

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFFFE2CC),
      child: Center(
        child: Icon(
          memory.category.icon,
          size: 36,
          color: _primaryOrange.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
