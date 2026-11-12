import 'package:flutter/material.dart';

class StorageLoadingDialog extends StatelessWidget {
  const StorageLoadingDialog({super.key, required this.message});

  final String message;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _textColor = Color(0xFF38251F);

  static void show(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => StorageLoadingDialog(message: message),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(_primaryOrange),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: _textColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
