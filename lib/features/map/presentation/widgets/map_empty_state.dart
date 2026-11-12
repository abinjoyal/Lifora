import 'package:flutter/material.dart';

class MapEmptyState extends StatelessWidget {
  const MapEmptyState({
    super.key,
    required this.hasActiveFilters,
    required this.onClearFilters,
    required this.onAddMemory,
  });

  final bool hasActiveFilters;
  final VoidCallback onClearFilters;
  final VoidCallback onAddMemory;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
              Icons.location_off_rounded,
              size: 32,
              color: _primaryOrange,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            hasActiveFilters
                ? 'No memories match your filter'
                : 'No mapped memories yet',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _mainText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasActiveFilters
                ? 'Try resetting the date or category filters to explore more locations.'
                : 'When you save memories with GPS or map locations, they will appear here.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: _secondaryText,
            ),
          ),
          const SizedBox(height: 18),
          if (hasActiveFilters)
            FilledButton.icon(
              onPressed: onClearFilters,
              style: FilledButton.styleFrom(
                backgroundColor: _primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reset Filters'),
            )
          else
            FilledButton.icon(
              onPressed: onAddMemory,
              style: FilledButton.styleFrom(
                backgroundColor: _primaryOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_location_alt_rounded, size: 18),
              label: const Text('Create Memory'),
            ),
        ],
      ),
    );
  }
}

