import 'package:flutter/material.dart';

class MemoriesViewToggle extends StatelessWidget {
  const MemoriesViewToggle({
    super.key,
    required this.isGridView,
    required this.onToggle,
  });

  final bool isGridView;
  final VoidCallback onToggle;

  static const Color _iconColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
      ),
      child: IconButton(
        icon: Icon(
          isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
          color: _iconColor,
          size: 20,
        ),
        tooltip: isGridView ? 'Switch to List View' : 'Switch to Grid View',
        onPressed: onToggle,
      ),
    );
  }
}
