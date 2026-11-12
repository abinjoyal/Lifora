import 'package:flutter/material.dart';

class ResetSettingsDialog extends StatelessWidget {
  const ResetSettingsDialog({
    super.key,
    required this.onConfirm,
  });

  final VoidCallback onConfirm;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _peach.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restore_rounded,
                color: _primaryOrange,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Reset App Preferences?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _mainText,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This will reset your theme, language and display options to system defaults.\n\nYour memories, photos and storage folder will NOT be deleted.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: _secondaryText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: _secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

