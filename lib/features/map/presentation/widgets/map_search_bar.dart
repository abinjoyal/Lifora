import 'package:flutter/material.dart';

class MapSearchBar extends StatefulWidget {
  const MapSearchBar({
    super.key,
    required this.initialQuery,
    required this.onSearchChanged,
    required this.onFilterTap,
    required this.hasActiveFilters,
    required this.onBack,
  });

  final String initialQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;
  final bool hasActiveFilters;
  final VoidCallback onBack;

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  late final TextEditingController _controller;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12.0,
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
              onChanged: widget.onSearchChanged,
              style: const TextStyle(
                fontSize: 14.0,
                color: _mainText,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: 'Search places, titles or tags...',
                hintStyle: TextStyle(
                  color: _secondaryText,
                  fontSize: 14.0,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_rounded, size: 18, color: _secondaryText),
              onPressed: () {
                _controller.clear();
                widget.onSearchChanged('');
                setState(() {});
              },
            ),
          // Filter button with badge if active
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  Icons.tune_rounded,
                  color: widget.hasActiveFilters ? _primaryOrange : _mainText,
                ),
                onPressed: widget.onFilterTap,
                tooltip: 'Filter Memories',
              ),
              if (widget.hasActiveFilters)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _primaryOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

