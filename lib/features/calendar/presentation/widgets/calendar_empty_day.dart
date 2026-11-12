import 'package:flutter/material.dart';

class CalendarEmptyDay extends StatelessWidget {
  const CalendarEmptyDay({
    super.key,
    required this.selectedDate,
    required this.onAddMemory,
  });

  final DateTime selectedDate;
  final VoidCallback onAddMemory;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _peach.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_note_rounded,
              size: 28,
              color: _primaryOrange,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No memories on this day',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _mainText,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Capture a special moment, photo or thought.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: _secondaryText,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onAddMemory,
            style: FilledButton.styleFrom(
              backgroundColor: _primaryOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text(
              'Add Memory',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

