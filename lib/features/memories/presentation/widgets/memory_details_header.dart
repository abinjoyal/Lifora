import 'package:flutter/material.dart';

class MemoryDetailsHeader extends StatelessWidget {
  const MemoryDetailsHeader({
    super.key,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
  });

  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  static const Color _iconColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _iconColor,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  color: isFavorite ? const Color(0xFFE91E63) : _iconColor,
                  size: 24,
                ),
                tooltip: isFavorite ? 'Unfavorite' : 'Favorite',
                onPressed: onToggleFavorite,
              ),
              IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                  color: _iconColor,
                  size: 22,
                ),
                tooltip: 'Share Memory',
                onPressed: onShare,
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: _iconColor,
                  size: 22,
                ),
                tooltip: 'Edit Memory',
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFD32F2F),
                  size: 22,
                ),
                tooltip: 'Delete Memory',
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
