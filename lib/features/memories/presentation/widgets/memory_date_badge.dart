import 'package:flutter/material.dart';
import '../../../../shared/extensions/date_extensions.dart';

class MemoryDateBadge extends StatelessWidget {
  const MemoryDateBadge({
    super.key,
    required this.date,
    this.backgroundColor = const Color(0xFFFFE2CC),
    this.textColor = const Color(0xFFB94E2D),
  });

  final DateTime date;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded, size: 12.0, color: textColor),
          const SizedBox(width: 4.0),
          Text(
            date.toReadableDate(),
            style: TextStyle(
              color: textColor,
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
