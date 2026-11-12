import 'package:flutter/material.dart';

class StorageBenefits extends StatelessWidget {
  const StorageBenefits({super.key});

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _textColor = Color(0xFF38251F);

  static const List<String> _benefits = [
    'Your files stay strictly under your control on your device.',
    'Works 100% offline with zero cloud account dependencies.',
    'Original photos and videos are preserved without compression.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2CC).withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: _benefits.map((benefit) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: _primaryOrange,
                  size: 20.0,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    benefit,
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
