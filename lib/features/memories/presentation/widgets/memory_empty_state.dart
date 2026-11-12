import 'package:flutter/material.dart';

class MemoryEmptyState extends StatelessWidget {
  const MemoryEmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.onAddMemory,
  });

  final String title;
  final String message;
  final VoidCallback onAddMemory;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _descColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE2CC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_stories_outlined,
                color: _primaryOrange,
                size: 42,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _titleColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _descColor,
                fontSize: 14.0,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onPressed: onAddMemory,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text(
                'Add a Memory',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
