import 'package:flutter/material.dart';
import '../../domain/entities/calendar_day.dart';
import 'calendar_day_cell.dart';

class CalendarMonthGrid extends StatelessWidget {
  const CalendarMonthGrid({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.onSelectDate,
  });

  final List<CalendarDay> days;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectDate;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Split days into rows of 7
    final List<List<CalendarDay>> weeks = [];
    for (int i = 0; i < days.length; i += 7) {
      final end = (i + 7 < days.length) ? i + 7 : days.length;
      weeks.add(days.sublist(i, end));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: weeks.map((week) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: week.map((day) {
              final isSelected = day.date.year == selectedDate.year &&
                  day.date.month == selectedDate.month &&
                  day.date.day == selectedDate.day;

              return Expanded(
                child: CalendarDayCell(
                  day: day,
                  isSelected: isSelected,
                  onTap: () => onSelectDate(day.date),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

