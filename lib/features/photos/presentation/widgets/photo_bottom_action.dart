import 'package:flutter/material.dart';

class PhotoBottomAction extends StatelessWidget {
  const PhotoBottomAction({
    super.key,
    required this.selectedCount,
    required this.onAdd,
  });

  final int selectedCount;
  final VoidCallback onAdd;

  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    if (selectedCount == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFEADBCE), width: 0.8),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              elevation: 0,
            ),
            onPressed: onAdd,
            child: Text(
              'Add $selectedCount Photo${selectedCount == 1 ? '' : 's'} to Memory',
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

