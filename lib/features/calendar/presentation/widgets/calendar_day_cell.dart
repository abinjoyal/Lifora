import 'package:flutter/material.dart';
import '../../domain/entities/calendar_day.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final CalendarDay day;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _darkOrange = Color(0xFFB94E2D);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    final hasMemories = day.hasMemories;
    final memoryCount = day.memoryCount;
    final isToday = day.isToday;
    final isCurrentMonth = day.isCurrentMonth;

    Color textColor;
    if (isSelected) {
      textColor = Colors.white;
    } else if (!isCurrentMonth) {
      textColor = _secondaryText.withValues(alpha: 0.35);
    } else if (isToday) {
      textColor = _primaryOrange;
    } else {
      textColor = _mainText;
    }

    BoxDecoration? decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: _primaryOrange,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _primaryOrange.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      );
    } else if (isToday) {
      decoration = BoxDecoration(
        color: _peach.withValues(alpha: 0.4),
        shape: BoxShape.circle,
        border: Border.all(color: _primaryOrange, width: 1.5),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      splashColor: _peach.withValues(alpha: 0.5),
      child: Container(
        margin: const EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: decoration,
              alignment: Alignment.center,
              child: Text(
                '${day.date.day}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 3),
            // Memory indicator
            _buildMemoryIndicator(
              hasMemories: hasMemories,
              memoryCount: memoryCount,
              isSelected: isSelected,
              isCurrentMonth: isCurrentMonth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryIndicator({
    required bool hasMemories,
    required int memoryCount,
    required bool isSelected,
    required bool isCurrentMonth,
  }) {
    if (!hasMemories) {
      return const SizedBox(height: 6);
    }

    final dotColor = isSelected ? _darkOrange : _primaryOrange;

    if (memoryCount == 1) {
      return Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          color: isCurrentMonth ? dotColor : dotColor.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
      );
    }

    // Multiple memories: show 2 or 3 dots
    final dotCount = memoryCount.clamp(2, 3);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        dotCount,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.0),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: isCurrentMonth ? dotColor : dotColor.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

