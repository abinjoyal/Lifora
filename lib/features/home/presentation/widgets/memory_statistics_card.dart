import 'package:flutter/material.dart';

class MemoryStatisticsCard extends StatelessWidget {
  const MemoryStatisticsCard({
    super.key,
    required this.totalMemories,
    required this.totalEvents,
    required this.totalTrips,
  });

  final int totalMemories;
  final int totalEvents;
  final int totalTrips;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _descColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38251F).withValues(alpha: 0.04),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Stat 1: Total Memories
          _buildStatColumn(
            label: 'Memories',
            count: totalMemories,
            icon: Icons.photo_library_rounded,
            color: _primaryOrange,
          ),
          _buildDivider(),

          // Stat 2: Total Events
          _buildStatColumn(
            label: 'Events',
            count: totalEvents,
            icon: Icons.celebration_rounded,
            color: const Color(0xFFE08700),
          ),
          _buildDivider(),

          // Stat 3: Total Trips
          _buildStatColumn(
            label: 'Trips',
            count: totalTrips,
            icon: Icons.flight_takeoff_rounded,
            color: const Color(0xFF3B8A5A),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
    required String label,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22.0),
          const SizedBox(height: 6.0),
          Text(
            count.toString(),
            style: const TextStyle(
              color: _titleColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: const TextStyle(
              color: _descColor,
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 38.0, width: 1.0, color: const Color(0xFFEADBCE));
  }
}
