import 'package:flutter/material.dart';

class LocationConfirmButton extends StatelessWidget {
  const LocationConfirmButton({
    super.key,
    required this.onConfirm,
    this.label = 'Confirm Location',
    this.isEnabled = true,
  });

  final VoidCallback onConfirm;
  final String label;
  final bool isEnabled;

  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
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
              disabledBackgroundColor: const Color(0xFFEADBCE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              elevation: 0,
            ),
            onPressed: isEnabled ? onConfirm : null,
            child: Text(
              label,
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

