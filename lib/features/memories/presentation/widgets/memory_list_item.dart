import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/memory.dart';
import 'memory_date_badge.dart';

class MemoryListItem extends StatelessWidget {
  const MemoryListItem({
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
  static const Color _descColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    final cover = memory.coverPhoto;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38251F).withValues(alpha: 0.04),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Left: Square Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child:
                          cover?.localPath != null &&
                              File(cover!.localPath!).existsSync()
                          ? Image.file(
                              File(cover.localPath!),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: const Color(0xFFFFE2CC),
                              child: Icon(
                                memory.category.icon,
                                size: 30,
                                color: _primaryOrange,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14.0),

                  // Middle: Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          memory.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _titleColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        MemoryDateBadge(date: memory.date),
                        if (memory.location != null) ...[
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                size: 12.0,
                                color: _descColor,
                              ),
                              const SizedBox(width: 2.0),
                              Expanded(
                                child: Text(
                                  memory.location!.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _descColor,
                                    fontSize: 11.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Right: Favorite Heart
                  IconButton(
                    icon: Icon(
                      memory.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: memory.isFavorite
                          ? const Color(0xFFE91E63)
                          : const Color(0xFF806A60),
                      size: 22.0,
                    ),
                    onPressed: onToggleFavorite,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
