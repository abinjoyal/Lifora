import 'package:flutter/material.dart';
import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/enums/memory_sort_type.dart';
import '../../domain/entities/search_filter.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  const SearchFilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  final SearchFilter initialFilter;
  final ValueChanged<SearchFilter> onApply;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  State<SearchFilterBottomSheet> createState() => _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  late SearchDateFilterType _dateFilter;
  late Set<MemoryCategory> _selectedCategories;
  late SearchLocationFilterType _locationFilter;
  late bool _isFavoriteOnly;
  late MemorySortType _sortType;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _dateFilter = widget.initialFilter.dateFilterType;
    _selectedCategories = Set.from(widget.initialFilter.categories);
    _locationFilter = widget.initialFilter.locationFilterType;
    _isFavoriteOnly = widget.initialFilter.isFavoriteOnly;
    _sortType = widget.initialFilter.sortType;
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Search Filters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: SearchFilterBottomSheet._mainText,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _dateFilter = SearchDateFilterType.allTime;
                        _selectedCategories.clear();
                        _locationFilter = SearchLocationFilterType.all;
                        _isFavoriteOnly = false;
                        _sortType = MemorySortType.newest;
                        _startDate = null;
                        _endDate = null;
                      });
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: SearchFilterBottomSheet._primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFF0E5DB), height: 1),
              const SizedBox(height: 14),

              // 1. Date Range Filter
              const Text(
                'Date Range',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: SearchFilterBottomSheet._mainText,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildDateChip('All Time', SearchDateFilterType.allTime),
                  _buildDateChip('Today', SearchDateFilterType.today),
                  _buildDateChip('This Week', SearchDateFilterType.thisWeek),
                  _buildDateChip('This Month', SearchDateFilterType.thisMonth),
                  _buildDateChip('This Year', SearchDateFilterType.thisYear),
                  _buildDateChip('Custom Range', SearchDateFilterType.customRange),
                ],
              ),
              if (_dateFilter == SearchDateFilterType.customRange) ...[
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
              const SizedBox(height: 18),

              // 2. Categories Multi-Select
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: SearchFilterBottomSheet._mainText,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MemoryCategory.values.map((cat) {
                  final isSelected = _selectedCategories.contains(cat);
                  return FilterChip(
                    label: Text(cat.displayName),
                    selected: isSelected,
                    avatar: Icon(
                      cat.icon,
                      size: 16,
                      color: isSelected ? Colors.white : SearchFilterBottomSheet._primaryOrange,
                    ),
                    selectedColor: SearchFilterBottomSheet._primaryOrange,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : SearchFilterBottomSheet._mainText,
                    ),
                    backgroundColor: SearchFilterBottomSheet._peach.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected
                            ? SearchFilterBottomSheet._primaryOrange
                            : const Color(0xFFEADBCE),
                        width: 0.8,
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategories.add(cat);
                        } else {
                          _selectedCategories.remove(cat);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // 3. Location Filter
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: SearchFilterBottomSheet._mainText,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildLocationChip('All', SearchLocationFilterType.all),
                  _buildLocationChip('Has Location', SearchLocationFilterType.hasLocation),
                  _buildLocationChip('No Location', SearchLocationFilterType.noLocation),
                ],
              ),
              const SizedBox(height: 18),

              // 4. Favorites Toggle
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8F1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Starred / Favorite Only',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: SearchFilterBottomSheet._mainText,
                    ),
                  ),
                  subtitle: const Text(
                    'Show only memories marked as favorites',
                    style: TextStyle(
                      fontSize: 12,
                      color: SearchFilterBottomSheet._secondaryText,
                    ),
                  ),
                  secondary: const Icon(
                    Icons.favorite_rounded,
                    color: SearchFilterBottomSheet._primaryOrange,
                  ),
                  activeThumbColor: SearchFilterBottomSheet._primaryOrange,
                  value: _isFavoriteOnly,
                  onChanged: (val) {
                    setState(() {
                      _isFavoriteOnly = val;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),

              // 5. Sort Order
              const Text(
                'Sort Order',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: SearchFilterBottomSheet._mainText,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildSortChip('Newest First', MemorySortType.newest),
                  _buildSortChip('Oldest First', MemorySortType.oldest),
                  _buildSortChip('A - Z', MemorySortType.alphabetical),
                ],
              ),
              const SizedBox(height: 24),

              // Apply Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    final newFilter = widget.initialFilter.copyWith(
                      dateFilterType: _dateFilter,
                      categories: _selectedCategories,
                      locationFilterType: _locationFilter,
                      isFavoriteOnly: _isFavoriteOnly,
                      sortType: _sortType,
                      customStartDate: _startDate,
                      customEndDate: _endDate,
                    );
                    widget.onApply(newFilter);
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: SearchFilterBottomSheet._primaryOrange,
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
      ),
    );
  }

  Widget _buildDateChip(String label, SearchDateFilterType type) {
    final isSelected = _dateFilter == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: SearchFilterBottomSheet._primaryOrange,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? Colors.white : SearchFilterBottomSheet._mainText,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected
              ? SearchFilterBottomSheet._primaryOrange
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

  Widget _buildLocationChip(String label, SearchLocationFilterType type) {
    final isSelected = _locationFilter == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: SearchFilterBottomSheet._primaryOrange,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? Colors.white : SearchFilterBottomSheet._mainText,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected
              ? SearchFilterBottomSheet._primaryOrange
              : const Color(0xFFEADBCE),
          width: 0.8,
        ),
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _locationFilter = type;
          });
        }
      },
    );
  }

  Widget _buildSortChip(String label, MemorySortType type) {
    final isSelected = _sortType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: SearchFilterBottomSheet._primaryOrange,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? Colors.white : SearchFilterBottomSheet._mainText,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected
              ? SearchFilterBottomSheet._primaryOrange
              : const Color(0xFFEADBCE),
          width: 0.8,
        ),
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _sortType = type;
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
              primary: SearchFilterBottomSheet._primaryOrange,
              onPrimary: Colors.white,
              onSurface: SearchFilterBottomSheet._mainText,
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

