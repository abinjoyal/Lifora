import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calendar_provider.dart';
import '../providers/calendar_year_provider.dart';
import '../widgets/calendar_year_overview.dart';

class CalendarYearPage extends ConsumerStatefulWidget {
  const CalendarYearPage({
    super.key,
    required this.initialYear,
  });

  final int initialYear;

  @override
  ConsumerState<CalendarYearPage> createState() => _CalendarYearPageState();
}

class _CalendarYearPageState extends ConsumerState<CalendarYearPage> {
  late int _selectedYear;

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    final yearState = ref.watch(calendarYearNotifierProvider(_selectedYear));

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('Year Overview'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _mainText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Year Navigator Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, size: 32),
                      color: _mainText,
                      onPressed: () {
                        setState(() {
                          _selectedYear -= 1;
                        });
                      },
                    ),
                    Text(
                      '$_selectedYear',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _mainText,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, size: 32),
                      color: _mainText,
                      onPressed: () {
                        setState(() {
                          _selectedYear += 1;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Total count card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _peach.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.collections_bookmark_rounded,
                        color: _primaryOrange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${yearState.totalMemories} Memories',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: _mainText,
                          ),
                        ),
                        Text(
                          'Recorded across $_selectedYear',
                          style: const TextStyle(
                            fontSize: 13,
                            color: _secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // 12 Months Grid Overview
              if (yearState.isLoading)
                const SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(color: _primaryOrange),
                  ),
                )
              else
                CalendarYearOverview(
                  monthCounts: yearState.monthCounts,
                  onMonthSelected: (month) {
                    // Update calendar state to this month & year and return
                    final targetDate = DateTime(_selectedYear, month, 1);
                    ref
                        .read(calendarNotifierProvider.notifier)
                        .selectDate(targetDate);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
