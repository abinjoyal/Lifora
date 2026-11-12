import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../memories/domain/entities/memory.dart';
import 'calendar_empty_day.dart';
import 'calendar_memory_card.dart';

class CalendarSelectedDaySection extends StatelessWidget {
  const CalendarSelectedDaySection({
    super.key,
    required this.selectedDate,
    required this.memories,
  });

  final DateTime selectedDate;
  final List<Memory> memories;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);

  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final weekdayName = _weekdays[selectedDate.weekday - 1];
    final monthName = _months[selectedDate.month - 1];
    final formattedDate = '$weekdayName, $monthName ${selectedDate.day}, ${selectedDate.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _mainText,
                ),
              ),
              if (memories.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _peach.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${memories.length} ${memories.length == 1 ? 'memory' : 'memories'}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _primaryOrange,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // List of memories or empty state
        if (memories.isEmpty)
          CalendarEmptyDay(
            selectedDate: selectedDate,
            onAddMemory: () {
              context.push(RouteConstants.createMemoryPath, extra: selectedDate);
            },
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: memories.length,
            itemBuilder: (context, index) {
              return CalendarMemoryCard(memory: memories[index]);
            },
          ),
      ],
    );
  }
}

