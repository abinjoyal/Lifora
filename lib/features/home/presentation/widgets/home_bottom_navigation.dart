import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({super.key, this.selectedIndex = 0});

  final int selectedIndex;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _darkOrange = Color(0xFFB94E2D);
  static const Color _inactiveColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFEADBCE), width: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Home Item
              _buildNavItem(
                context,
                index: 0,
                label: 'Home',
                icon: Icons.home_rounded,
                inactiveIcon: Icons.home_outlined,
                onTap: () {
                  // Already on home
                },
              ),

              // 2. Memories Item
              _buildNavItem(
                context,
                index: 1,
                label: 'Memories',
                icon: Icons.auto_stories_rounded,
                inactiveIcon: Icons.auto_stories_outlined,
                onTap: () => context.push(RouteConstants.memoriesPath),
              ),

              // 3. Central Add Memory Button
              _buildCenterAddButton(context),

              // 4. Timeline Item
              _buildNavItem(
                context,
                index: 3,
                label: 'Timeline',
                icon: Icons.calendar_month_rounded,
                inactiveIcon: Icons.calendar_month_outlined,
                onTap: () => context.push(RouteConstants.calendarPath),
              ),

              // 5. Profile Item
              _buildNavItem(
                context,
                index: 4,
                label: 'Profile',
                icon: Icons.person_rounded,
                inactiveIcon: Icons.person_outline_rounded,
                onTap: () => context.push(RouteConstants.profilePath),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required String label,
    required IconData icon,
    required IconData inactiveIcon,
    required VoidCallback onTap,
  }) {
    final bool isSelected = selectedIndex == index;
    final Color color = isSelected ? _primaryOrange : _inactiveColor;

    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: onTap,
      child: SizedBox(
        width: 62.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? icon : inactiveIcon, color: color, size: 24.0),
            const SizedBox(height: 3.0),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11.0,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteConstants.createMemoryPath),
      child: Container(
        width: 48.0,
        height: 48.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [_primaryOrange, _darkOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _primaryOrange.withValues(alpha: 0.4),
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28.0),
      ),
    );
  }
}
