import 'dart:async';
import 'package:flutter/material.dart';

class SearchInputField extends StatefulWidget {
  const SearchInputField({
    super.key,
    required this.initialQuery,
    required this.onQueryChanged,
    required this.onSubmitted,
    required this.onBack,
  });

  final String initialQuery;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onBack;

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  late final TextEditingController _controller;
  Timer? _debounceTimer;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(covariant SearchInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery != oldWidget.initialQuery &&
        widget.initialQuery != _controller.text) {
      _controller.text = widget.initialQuery;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onQueryChanged(value);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: _mainText),
            onPressed: widget.onBack,
            tooltip: 'Back',
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              onSubmitted: (val) {
                _debounceTimer?.cancel();
                widget.onSubmitted(val);
              },
              style: const TextStyle(
                fontSize: 15.0,
                color: _mainText,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'Search your memories...',
                hintStyle: TextStyle(
                  color: _secondaryText,
                  fontSize: 14.5,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.clear_rounded,
                size: 18,
                color: _secondaryText,
              ),
              onPressed: () {
                _controller.clear();
                _debounceTimer?.cancel();
                widget.onQueryChanged('');
                setState(() {});
              },
              tooltip: 'Clear',
            )
          else
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.search_rounded,
                color: _primaryOrange,
                size: 22,
              ),
            ),
        ],
      ),
    );
  }
}

