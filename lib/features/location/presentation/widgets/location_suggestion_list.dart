import 'package:flutter/material.dart';
import '../../domain/entities/memory_location.dart';

class LocationSuggestionList extends StatelessWidget {
  const LocationSuggestionList({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });

  final List<MemoryLocation> suggestions;
  final ValueChanged<MemoryLocation> onSelect;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _bodyColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
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
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: suggestions.length,
        separatorBuilder: (_, _) => const Divider(
          color: Color(0xFFEADBCE),
          height: 1.0,
          indent: 16.0,
          endIndent: 16.0,
        ),
        itemBuilder: (context, index) {
          final item = suggestions[index];
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            leading: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Color(0xFFFFE2CC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: _primaryOrange,
                size: 20.0,
              ),
            ),
            title: Text(
              item.name,
              style: const TextStyle(
                color: _titleColor,
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
            subtitle: item.address != null
                ? Text(
                    item.address!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _bodyColor,
                      fontSize: 12.0,
                    ),
                  )
                : null,
            onTap: () => onSelect(item),
          );
        },
      ),
    );
  }
}

