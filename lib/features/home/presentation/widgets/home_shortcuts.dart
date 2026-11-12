import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import 'shortcut_item.dart';

class HomeShortcuts extends StatelessWidget {
  const HomeShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          ShortcutItem(
            label: 'Memories',
            icon: Icons.photo_library_outlined,
            iconColor: const Color(0xFFF47B45),
            onTap: () => context.push(RouteConstants.memoriesPath),
          ),
          const SizedBox(width: 10.0),
          ShortcutItem(
            label: 'Timeline',
            icon: Icons.calendar_month_outlined,
            iconColor: const Color(0xFFB94E2D),
            onTap: () => context.push(RouteConstants.calendarPath),
          ),
          const SizedBox(width: 10.0),
          ShortcutItem(
            label: 'Map View',
            icon: Icons.map_outlined,
            iconColor: const Color(0xFFE08700),
            onTap: () => context.push(RouteConstants.mapPath),
          ),
          const SizedBox(width: 10.0),
          ShortcutItem(
            label: 'Favorites',
            icon: Icons.favorite_outline_rounded,
            iconColor: const Color(0xFFE91E63),
            onTap: () => context.push(RouteConstants.favoritesPath),
          ),
        ],
      ),
    );
  }
}
