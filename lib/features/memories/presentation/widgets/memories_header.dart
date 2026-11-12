import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import 'memories_view_toggle.dart';

class MemoriesHeader extends StatelessWidget {
  const MemoriesHeader({
    super.key,
    required this.isGridView,
    required this.onToggleView,
  });

  final bool isGridView;
  final VoidCallback onToggleView;

  static const Color _titleColor = Color(0xFF38251F);
  static const Color _iconColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (Navigator.canPop(context)) ...[
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: _titleColor,
                    size: 20,
                  ),
                  tooltip: 'Back',
                  onPressed: () => Navigator.maybePop(context),
                ),
                const SizedBox(width: 4.0),
              ],
              const Text(
                'My Memories',
                style: TextStyle(
                  color: _titleColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.search_rounded,
                  color: _iconColor,
                  size: 24,
                ),
                tooltip: 'Search memories',
                onPressed: () => context.push(RouteConstants.searchPath),
              ),
              const SizedBox(width: 4.0),
              MemoriesViewToggle(
                isGridView: isGridView,
                onToggle: onToggleView,
              ),
              const SizedBox(width: 8.0),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: Color(0xFFF47B45),
                  size: 28,
                ),
                tooltip: 'Create Memory',
                onPressed: () => context.push(RouteConstants.createMemoryPath),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
