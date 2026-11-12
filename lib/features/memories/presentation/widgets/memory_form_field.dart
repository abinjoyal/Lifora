import 'package:flutter/material.dart';

class MemoryFormField extends StatelessWidget {
  const MemoryFormField({
    super.key,
    required this.label,
    required this.hint,
    this.initialValue,
    this.controller,
    this.prefixIcon,
    this.onChanged,
    this.maxLines = 1,
    this.validator,
  });

  final String label;
  final String hint;
  final String? initialValue;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final FormFieldValidator<String>? validator;

  static const Color _titleColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _titleColor,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: const BorderSide(color: Color(0xFFEADBCE)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: const BorderSide(color: Color(0xFFEADBCE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: const BorderSide(
                color: Color(0xFFF47B45),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
