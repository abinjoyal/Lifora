import 'package:flutter/material.dart';

class LocationEmptyState extends StatelessWidget {
  const LocationEmptyState({
    super.key,
    this.title = 'No Locations Found',
    this.message = 'Try searching with a different city, landmark or place name.',
    this.onAction,
    this.actionLabel,
  });

  final String title;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _bodyColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Color(0xFFFFE2CC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.travel_explore_rounded,
                size: 44.0,
                color: _primaryOrange,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                color: _titleColor,
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _bodyColor, fontSize: 13.0, height: 1.4),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

