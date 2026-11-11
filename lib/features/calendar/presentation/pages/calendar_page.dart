import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/calendar_provider.dart';
import '../widgets/calendar_header.dart';
import '../widgets/calendar_month_grid.dart';
import '../widgets/calendar_selected_day_section.dart';
import '../widgets/calendar_stats_card.dart';
import '../widgets/calendar_weekday_header.dart';

class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarNotifierProvider);
    final notifier = ref.read(calendarNotifierProvider.notifier);

    // Calculate count of memories in the viewed month
    final monthMemoriesCount = calendarState.days
        .where((d) => d.isCurrentMonth)
        .fold<int>(0, (sum, d) => sum + d.memoryCount);

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        child: RefreshIndicator(
          color: _primaryOrange,
          backgroundColor: Colors.white,
          onRefresh: () async {
            notifier.refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Calendar Header (Title, Month, Today, Year view)
                CalendarHeader(
                  year: calendarState.viewYear,
                  month: calendarState.viewMonth,
                  onPreviousMonth: notifier.previousMonth,
                  onNextMonth: notifier.nextMonth,
                  onToday: notifier.jumpToToday,
                  onYearView: () {
                    context.push(
                      RouteConstants.calendarYearUrl(calendarState.viewYear),
                    );
                  },
                ),

                // 2. Calendar Statistics Card
                CalendarStatsCard(
                  stats: calendarState.stats,
                  monthMemoriesCount: monthMemoriesCount,
                ),
                const SizedBox(height: 8),

                // 3. Calendar Container (Weekday Header + Days Grid)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: const Color(0xFFEADBCE),
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _mainText.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const CalendarWeekdayHeader(),
                      const Divider(
                        color: Color(0xFFF0E5DB),
                        height: 1,
                        thickness: 0.8,
                      ),
                      const SizedBox(height: 8),
                      CalendarMonthGrid(
                        days: calendarState.days,
                        selectedDate: calendarState.selectedDate,
                        onSelectDate: (date) {
                          notifier.selectDate(date);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Selected Day Memories Section
                CalendarSelectedDaySection(
                  selectedDate: calendarState.selectedDate,
                  memories: calendarState.selectedDateMemories,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryOrange,
        foregroundColor: Colors.white,
        tooltip: 'Add Memory for Date',
        onPressed: () => context.push(
          RouteConstants.createMemoryPath,
          extra: calendarState.selectedDate,
        ),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
