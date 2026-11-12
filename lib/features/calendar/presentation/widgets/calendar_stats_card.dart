import 'package:flutter/material.dart';
import '../../domain/entities/calendar_stats.dart';

class CalendarStatsCard extends StatelessWidget {
  const CalendarStatsCard({
    super.key,
    required this.stats,
    required this.monthMemoriesCount,
  });

  final CalendarStats? stats;
  final int monthMemoriesCount;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    final yearCount = stats?.yearMemoryCount ?? 0;
    final totalCount = stats?.totalMemories ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: _mainText.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem(
            label: 'This Month',
            value: '$monthMemoriesCount',
            icon: Icons.calendar_today_rounded,
          ),
          Container(
            height: 32,
            width: 1,
            color: const Color(0xFFEADBCE),
          ),
          _buildStatItem(
            label: 'This Year',
            value: '$yearCount',
            icon: Icons.date_range_rounded,
          ),
          Container(
            height: 32,
            width: 1,
            color: const Color(0xFFEADBCE),
          ),
          _buildStatItem(
            label: 'All Time',
            value: '$totalCount',
            icon: Icons.auto_awesome_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _peach.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 14,
              color: _primaryOrange,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _mainText,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: _secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
