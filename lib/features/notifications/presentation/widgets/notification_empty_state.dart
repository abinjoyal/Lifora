import 'package:flutter/material.dart';

class NotificationEmptyState extends StatelessWidget {
  const NotificationEmptyState({super.key});

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _peach.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 40,
                color: _primaryOrange,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'All Caught Up!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _mainText,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'You have no new notifications. Memory reminders and "On This Day" moments will arrive here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: _secondaryText,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

