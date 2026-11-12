import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../memories/domain/entities/memory.dart';
import '../../../memories/presentation/providers/memory_provider.dart';
import '../../domain/entities/memory_reminder.dart';
import '../providers/reminder_provider.dart';

class CreateReminderPage extends ConsumerStatefulWidget {
  const CreateReminderPage({super.key, this.initialReminder});

  final MemoryReminder? initialReminder;

  @override
  ConsumerState<CreateReminderPage> createState() =>
      _CreateReminderPageState();
}

class _CreateReminderPageState extends ConsumerState<CreateReminderPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late ReminderCategoryType _selectedCategory;
  late ReminderRepeatType _selectedRepeat;
  String? _selectedLinkedMemoryId;

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  void initState() {
    super.initState();
    final initial = widget.initialReminder;

    _titleController = TextEditingController(text: initial?.title ?? '');
    _descController = TextEditingController(text: initial?.description ?? '');

    _selectedDate = initial?.reminderDate ?? DateTime.now();
    _selectedTime = initial != null
        ? TimeOfDay(
            hour: initial.reminderTimeHour,
            minute: initial.reminderTimeMinute,
          )
        : TimeOfDay.now();

    _selectedCategory = initial?.categoryType ?? ReminderCategoryType.general;
    _selectedRepeat = initial?.repeatType ?? ReminderRepeatType.never;
    _selectedLinkedMemoryId = initial?.linkedMemoryId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialReminder != null;
    final memoryListAsync = ref.watch(memoryListNotifierProvider);

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Reminder' : 'New Reminder'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Title Input
                const Text(
                  'Reminder Title *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _mainText,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _titleController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter a title for this reminder';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'e.g. Grandma\'s Birthday or Trip Anniversary',
                    hintStyle: const TextStyle(fontSize: 14, color: _secondaryText),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEADBCE)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEADBCE)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _primaryOrange),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Description Input
                const Text(
                  'Description (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _mainText,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _descController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Add personal notes or what you want to remember...',
                    hintStyle: const TextStyle(fontSize: 14, color: _secondaryText),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEADBCE)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFEADBCE)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _primaryOrange),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Category Selector
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _mainText,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ReminderCategoryType.values.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(_getCategoryLabel(cat)),
                      selected: isSelected,
                      selectedColor: _primaryOrange,
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : _mainText,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected
                              ? _primaryOrange
                              : const Color(0xFFEADBCE),
                        ),
                      ),
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // 4. Date & Time Selection
                Row(
                  children: [
                    // Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reminder Date',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _mainText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFEADBCE)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 16,
                                    color: _primaryOrange,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: _mainText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reminder Time',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _mainText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: _pickTime,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFEADBCE)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 16,
                                    color: _primaryOrange,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: _mainText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 5. Repeat Options
                const Text(
                  'Repeat Frequency',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _mainText,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ReminderRepeatType.values.map((repeat) {
                    final isSelected = _selectedRepeat == repeat;
                    return ChoiceChip(
                      label: Text(_getRepeatLabel(repeat)),
                      selected: isSelected,
                      selectedColor: _primaryOrange,
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : _mainText,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected
                              ? _primaryOrange
                              : const Color(0xFFEADBCE),
                        ),
                      ),
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedRepeat = repeat;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // 6. Optional Linked Memory Picker
                const Text(
                  'Link to a Memory (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _mainText,
                  ),
                ),
                const SizedBox(height: 6),
                memoryListAsync.when(
                  data: (memories) {
                    if (memories.isEmpty) {
                      return const Text(
                        'No memories saved yet to link.',
                        style: TextStyle(fontSize: 12, color: _secondaryText),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEADBCE)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _selectedLinkedMemoryId,
                          isExpanded: true,
                          hint: const Text(
                            'Select memory to open when tapped',
                            style: TextStyle(fontSize: 13, color: _secondaryText),
                          ),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('None (General reminder)'),
                            ),
                            ...memories.map((Memory m) {
                              return DropdownMenuItem<String?>(
                                value: m.id,
                                child: Text(
                                  m.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              );
                            }),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _selectedLinkedMemoryId = val;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 32),

                // 7. Save Action Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _saveReminder,
                    style: FilledButton.styleFrom(
                      backgroundColor: _primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Save Changes' : 'Schedule Reminder',
                      style: const TextStyle(
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
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(now) ? now : _selectedDate,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryOrange,
              onPrimary: Colors.white,
              onSurface: _mainText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryOrange,
              onPrimary: Colors.white,
              onSurface: _mainText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveReminder() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final reminder = MemoryReminder(
      id: widget.initialReminder?.id ??
          'rem_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descController.text.trim().isNotEmpty
          ? _descController.text.trim()
          : null,
      reminderDate: _selectedDate,
      reminderTimeHour: _selectedTime.hour,
      reminderTimeMinute: _selectedTime.minute,
      linkedMemoryId: _selectedLinkedMemoryId,
      categoryType: _selectedCategory,
      repeatType: _selectedRepeat,
      isEnabled: widget.initialReminder?.isEnabled ?? true,
      createdAt: widget.initialReminder?.createdAt ?? now,
      updatedAt: now,
    );

    ref.read(reminderNotifierProvider.notifier).saveReminder(reminder);
    Navigator.pop(context);
  }

  String _getCategoryLabel(ReminderCategoryType cat) {
    switch (cat) {
      case ReminderCategoryType.general:
        return 'General';
      case ReminderCategoryType.birthday:
        return 'Birthday';
      case ReminderCategoryType.anniversary:
        return 'Anniversary';
      case ReminderCategoryType.trip:
        return 'Trip';
      case ReminderCategoryType.custom:
        return 'Custom';
    }
  }

  String _getRepeatLabel(ReminderRepeatType repeat) {
    switch (repeat) {
      case ReminderRepeatType.never:
        return 'Never (Once)';
      case ReminderRepeatType.daily:
        return 'Daily';
      case ReminderRepeatType.weekly:
        return 'Weekly';
      case ReminderRepeatType.monthly:
        return 'Monthly';
      case ReminderRepeatType.yearly:
        return 'Yearly';
    }
  }
}
