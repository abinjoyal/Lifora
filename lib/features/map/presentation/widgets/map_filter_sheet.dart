import 'package:flutter/material.dart';
import '../../../../shared/enums/memory_category.dart';
import '../../domain/entities/map_filter.dart';

class MapFilterSheet extends StatefulWidget {
  const MapFilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  final MapFilter initialFilter;
  final ValueChanged<MapFilter> onApply;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);

  @override
  State<MapFilterSheet> createState() => _MapFilterSheetState();
}

class _MapFilterSheetState extends State<MapFilterSheet> {
  late MapDateFilterType _dateFilter;
  late Set<MemoryCategory> _selectedCategories;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _dateFilter = widget.initialFilter.dateFilterType;
    _selectedCategories = Set.from(widget.initialFilter.categories);
    _startDate = widget.initialFilter.customStartDate;
    _endDate = widget.initialFilter.customEndDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Memories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: MapFilterSheet._mainText,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _dateFilter = MapDateFilterType.allTime;
                      _selectedCategories.clear();
                      _startDate = null;
                      _endDate = null;
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: MapFilterSheet._primaryOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date Filters
            const Text(
              'Date Range',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MapFilterSheet._mainText,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildDateChip('All Time', MapDateFilterType.allTime),
                _buildDateChip('This Month', MapDateFilterType.thisMonth),
                _buildDateChip('This Year', MapDateFilterType.thisYear),
                _buildDateChip('Custom Range', MapDateFilterType.customRange),
              ],
            ),
            if (_dateFilter == MapDateFilterType.customRange) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickDateRange,
                icon: const Icon(Icons.date_range_rounded, size: 16),
                label: Text(
                  _startDate != null && _endDate != null
                      ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                      : 'Select Date Range',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Category Filters
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MapFilterSheet._mainText,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MemoryCategory.values.map((category) {
                final isSelected = _selectedCategories.contains(category);
                return FilterChip(
                  label: Text(category.displayName),
                  selected: isSelected,
                  avatar: Icon(
                    category.icon,
                    size: 16,
                    color: isSelected ? Colors.white : MapFilterSheet._primaryOrange,
                  ),
                  selectedColor: MapFilterSheet._primaryOrange,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : MapFilterSheet._mainText,
                  ),
                  backgroundColor: MapFilterSheet._peach.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected
                          ? MapFilterSheet._primaryOrange
                          : const Color(0xFFEADBCE),
                      width: 0.8,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(category);
                      } else {
                        _selectedCategories.remove(category);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  final newFilter = widget.initialFilter.copyWith(
                    dateFilterType: _dateFilter,
                    categories: _selectedCategories,
                    customStartDate: _startDate,
                    customEndDate: _endDate,
                  );
                  widget.onApply(newFilter);
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: MapFilterSheet._primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateChip(String label, MapDateFilterType type) {
    final isSelected = _dateFilter == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: MapFilterSheet._primaryOrange,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? Colors.white : MapFilterSheet._mainText,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected
              ? MapFilterSheet._primaryOrange
              : const Color(0xFFEADBCE),
          width: 0.8,
        ),
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _dateFilter = type;
          });
        }
      },
    );
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: MapFilterSheet._primaryOrange,
              onPrimary: Colors.white,
              onSurface: MapFilterSheet._mainText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }
}
