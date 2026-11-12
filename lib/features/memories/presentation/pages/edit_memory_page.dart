import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/extensions/date_extensions.dart';
import '../../domain/entities/memory.dart';
import '../providers/memory_detail_provider.dart';
import '../providers/memory_form_provider.dart';
import '../providers/memory_provider.dart';
import '../widgets/memory_form_bottom_bar.dart';
import '../widgets/memory_form_field.dart';
import '../widgets/memory_photo_selector.dart';
import 'package:lifora/features/location/domain/entities/memory_location.dart';
import 'package:lifora/features/location/presentation/pages/location_picker_page.dart';
import 'package:lifora/features/photos/presentation/pages/photo_picker_page.dart';
import 'package:lifora/features/photos/presentation/providers/photo_gallery_provider.dart';
import 'package:lifora/features/photos/presentation/widgets/photo_source_selector.dart';

class EditMemoryPage extends ConsumerWidget {
  const EditMemoryPage({super.key, required this.memoryId});

  final String memoryId;

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoryAsync = ref.watch(memoryDetailProvider(memoryId));

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('Edit Memory'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: memoryAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(_primaryOrange),
            ),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.orange,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text('Error loading memory: $e'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
          data: (memory) {
            if (memory == null) {
              return const Center(
                child: Text('Memory not found.'),
              );
            }
            return _EditMemoryForm(memory: memory);
          },
        ),
      ),
    );
  }
}

class _EditMemoryForm extends ConsumerStatefulWidget {
  const _EditMemoryForm({required this.memory});

  final Memory memory;

  @override
  ConsumerState<_EditMemoryForm> createState() => _EditMemoryFormState();
}

class _EditMemoryFormState extends ConsumerState<_EditMemoryForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _tagController;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.memory.title);
    _descriptionController =
        TextEditingController(text: widget.memory.description ?? '');
    _locationController =
        TextEditingController(text: widget.memory.location?.name ?? '');
    _tagController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(memoryFormProvider(widget.memory));
    final formNotifier = ref.read(memoryFormProvider(widget.memory).notifier);
    final listNotifier = ref.read(memoryListNotifierProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (formState.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            formState.errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Photos Selector
                MemoryPhotoSelector(
                  photos: formState.photos,
                  newPhotoPaths: formState.newPhotoPaths,
                  coverPhotoId: formState.coverPhotoId,
                  onAddPhotos: () => _pickPhotos(context, formNotifier),
                  onRemovePhoto: ({photoId, localPath}) =>
                      formNotifier.removePhoto(
                    photoId: photoId,
                    localPath: localPath,
                  ),
                  onSetCoverPhoto: (id) => formNotifier.setCoverPhotoId(id),
                ),
                const SizedBox(height: 20.0),

                // Title
                MemoryFormField(
                  label: 'Memory Title *',
                  hint: 'Title of your memory',
                  controller: _titleController,
                  onChanged: (val) => formNotifier.setTitle(val),
                ),
                const SizedBox(height: 16.0),

                // Date Picker
                _buildDatePicker(context, formState, formNotifier),
                const SizedBox(height: 16.0),

                // Category Selector
                _buildCategorySelector(formState, formNotifier),
                const SizedBox(height: 16.0),

                // Description
                MemoryFormField(
                  label: 'Journal Note',
                  hint: 'Write your thoughts...',
                  controller: _descriptionController,
                  maxLines: 4,
                  onChanged: (val) => formNotifier.setDescription(val),
                ),
                const SizedBox(height: 16.0),

                // Location
                InkWell(
                  borderRadius: BorderRadius.circular(14.0),
                  onTap: () async {
                    final loc = await Navigator.push<MemoryLocation>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LocationPickerPage(
                          initialLocation: formState.locationName.isNotEmpty
                              ? MemoryLocation(
                                  name: formState.locationName,
                                  latitude: formState.latitude,
                                  longitude: formState.longitude,
                                )
                              : null,
                        ),
                      ),
                    );
                    if (loc != null) {
                      _locationController.text = loc.name;
                      formNotifier.setLocation(
                        loc.name,
                        lat: loc.latitude,
                        lon: loc.longitude,
                      );
                    }
                  },
                  child: IgnorePointer(
                    child: MemoryFormField(
                      label: 'Location',
                      hint: 'Tap to change location (GPS, Map, Search)',
                      controller: _locationController,
                      prefixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: _primaryOrange,
                        size: 20,
                      ),
                      onChanged: (val) => formNotifier.setLocation(val),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Tags
                _buildTagsSection(formState, formNotifier),
                const SizedBox(height: 16.0),

                // Favorite Toggle
                _buildFavoriteSwitch(formState, formNotifier),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),

        // Bottom update bar
        MemoryFormBottomBar(
          buttonText: 'Update Memory',
          isLoading: formState.isSaving,
          onSave: () async {
            final success = await formNotifier.save(
              listNotifier,
              isEditing: true,
            );
            if (success && context.mounted) {
              ref.invalidate(memoryDetailProvider(widget.memory.id));
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    MemoryFormState formState,
    MemoryFormNotifier formNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _titleColor,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: formState.date,
              firstDate: DateTime(1950),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              formNotifier.setDate(picked);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: _primaryOrange,
                ),
                const SizedBox(width: 10),
                Text(
                  formState.date.toReadableDate(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: _titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Color(0xFF806A60),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(
    MemoryFormState formState,
    MemoryFormNotifier formNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _titleColor,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: MemoryCategory.values.map((cat) {
              final isSelected = formState.category == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(cat.displayName),
                  selected: isSelected,
                  selectedColor: const Color(0xFFFFE2CC),
                  checkmarkColor: _primaryOrange,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? _primaryOrange : const Color(0xFFEADBCE),
                    width: isSelected ? 1.2 : 0.8,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? _primaryOrange : const Color(0xFF38251F),
                  ),
                  onSelected: (_) => formNotifier.setCategory(cat),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(
    MemoryFormState formState,
    MemoryFormNotifier formNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _titleColor,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: 'Add a tag (e.g. family, trip)',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB0A29A),
                    fontSize: 13.5,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 12.0,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFEADBCE),
                      width: 0.8,
                    ),
                  ),
                ),
                onSubmitted: (tag) {
                  formNotifier.addTag(tag);
                  _tagController.clear();
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: _primaryOrange),
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                formNotifier.addTag(_tagController.text);
                _tagController.clear();
              },
            ),
          ],
        ),
        if (formState.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: formState.tags.map((tag) {
              return Chip(
                label: Text('#$tag', style: const TextStyle(fontSize: 12)),
                backgroundColor: const Color(0xFFFFE2CC),
                deleteIconColor: _primaryOrange,
                onDeleted: () => formNotifier.removeTag(tag),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildFavoriteSwitch(
    MemoryFormState formState,
    MemoryFormNotifier formNotifier,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                formState.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: formState.isFavorite ? Colors.red : const Color(0xFF806A60),
                size: 20,
              ),
              const SizedBox(width: 10),
              const Text(
                'Mark as Favorite',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _titleColor,
                ),
              ),
            ],
          ),
          Switch(
            value: formState.isFavorite,
            activeThumbColor: _primaryOrange,
            onChanged: (_) => formNotifier.toggleFavorite(),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhotos(
    BuildContext context,
    MemoryFormNotifier formNotifier,
  ) async {
    final choice = await PhotoSourceSelector.show(context);
    if (choice == null || !context.mounted) return;

    if (choice == PhotoSourceChoice.gallery) {
      final result = await Navigator.push<PhotoPickerResult>(
        context,
        MaterialPageRoute(builder: (_) => const PhotoPickerPage()),
      );
      if (result != null && result.photoPaths.isNotEmpty) {
        formNotifier.addPhotoPaths(result.photoPaths);
      }
    } else if (choice == PhotoSourceChoice.camera) {
      final capturePhoto = ref.read(capturePhotoUseCaseProvider);
      final path = await capturePhoto();
      if (path != null && path.isNotEmpty) {
        formNotifier.addPhotoPaths([path]);
      }
    }
  }
}

