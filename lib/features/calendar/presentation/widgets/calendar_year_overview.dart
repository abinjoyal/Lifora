import 'package:flutter/material.dart';

class CalendarYearOverview extends StatelessWidget {
  const CalendarYearOverview({
    super.key,
    required this.monthCounts,
    required this.onMonthSelected,
  });

  final Map<int, int> monthCounts;
  final ValueChanged<int> onMonthSelected;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  static const List<String> _shortMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 1.1,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        final monthName = _shortMonths[index];
        final count = monthCounts[month] ?? 0;
        final hasMemories = count > 0;

        return InkWell(
          onTap: () => onMonthSelected(month),
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: hasMemories ? _peach.withValues(alpha: 0.3) : Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: hasMemories
                    ? _primaryOrange.withValues(alpha: 0.5)
                    : const Color(0xFFEADBCE),
                width: hasMemories ? 1.2 : 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: _mainText.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  monthName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: hasMemories ? _primaryOrange : _mainText,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: hasMemories
                        ? _primaryOrange
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    hasMemories ? '$count' : '0',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: hasMemories ? Colors.white : _secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
