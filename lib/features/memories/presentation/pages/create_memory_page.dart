import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifora/features/location/domain/entities/memory_location.dart';
import 'package:lifora/features/location/presentation/pages/location_picker_page.dart';
import 'package:lifora/features/memories/presentation/providers/memory_form_provider.dart';
import 'package:lifora/features/memories/presentation/providers/memory_provider.dart';
import 'package:lifora/features/photos/presentation/pages/photo_picker_page.dart';
import 'package:lifora/features/photos/presentation/providers/photo_gallery_provider.dart';
import 'package:lifora/features/photos/presentation/widgets/photo_source_selector.dart';
import '../../../../features/notifications/presentation/providers/notification_provider.dart';
import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/extensions/date_extensions.dart';
import '../widgets/memory_form_bottom_bar.dart';
import '../widgets/memory_form_field.dart';
import '../widgets/memory_photo_selector.dart';

class CreateMemoryPage extends ConsumerStatefulWidget {
  const CreateMemoryPage({super.key, this.initialDate});

  final DateTime? initialDate;

  @override
  ConsumerState<CreateMemoryPage> createState() => _CreateMemoryPageState();
}

class _CreateMemoryPageState extends ConsumerState<CreateMemoryPage> {
  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(memoryFormProvider(null).notifier).setDate(widget.initialDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(memoryFormProvider(null));
    final formNotifier = ref.read(memoryFormProvider(null).notifier);
    final listNotifier = ref.read(memoryListNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('New Memory'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error banner if any
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

              // 1. Photos Selector
              MemoryPhotoSelector(
                photos: formState.photos,
                newPhotoPaths: formState.newPhotoPaths,
                coverPhotoId: formState.coverPhotoId,
                onAddPhotos: () => _pickPhotos(context, ref, formNotifier),
                onRemovePhoto: ({photoId, localPath}) => formNotifier
                    .removePhoto(photoId: photoId, localPath: localPath),
                onSetCoverPhoto: (id) => formNotifier.setCoverPhotoId(id),
              ),
              const SizedBox(height: 20.0),

              // 2. Memory Title
              MemoryFormField(
                label: 'Memory Title *',
                hint: 'e.g. Sunset walk at Marine Drive',
                onChanged: (val) => formNotifier.setTitle(val),
              ),
              const SizedBox(height: 16.0),

              // 3. Date Picker
              _buildDatePicker(context, formState, formNotifier),
              const SizedBox(height: 16.0),

              // 4. Category Selector
              _buildCategorySelector(formState, formNotifier),
              const SizedBox(height: 16.0),

              // 5. Description
              MemoryFormField(
                label: 'Journal Note',
                hint: 'What made this moment special? Who was with you?',
                maxLines: 4,
                onChanged: (val) => formNotifier.setDescription(val),
              ),
              const SizedBox(height: 16.0),

              // 6. Location
              _buildLocationField(context, formState, formNotifier),
              const SizedBox(height: 16.0),

              // 7. Favorite Toggle
              _buildFavoriteSwitch(formState, formNotifier),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MemoryFormBottomBar(
        isLoading: formState.isSaving,
        buttonText: 'Save Memory',
        onSave: () async {
          final memoryTitle = formState.title.trim().isNotEmpty
              ? formState.title.trim()
              : 'New Memory';
          final success = await formNotifier.save(
            listNotifier,
            isEditing: false,
          );
          if (success && context.mounted) {
            ref
                .read(notificationRepositoryProvider)
                .showMemorySavedConfirmation(memoryTitle);
            Navigator.pop(context);
          }
        },
      ),
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
          'Date of Memory',
          style: TextStyle(
            color: _titleColor,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8.0),
        InkWell(
          borderRadius: BorderRadius.circular(14.0),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: formState.date,
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              formNotifier.setDate(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 14.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(color: const Color(0xFFEADBCE)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: _primaryOrange,
                      size: 20,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      formState.date.toReadableDate(),
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: _titleColor,
                      ),
                    ),
                  ],
                ),
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
            color: _titleColor,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: MemoryCategory.values.map((cat) {
            final isSelected = formState.category == cat;
            return ChoiceChip(
              avatar: Icon(
                cat.icon,
                size: 16,
                color: isSelected ? Colors.white : _primaryOrange,
              ),
              label: Text(cat.displayName),
              selected: isSelected,
              selectedColor: _primaryOrange,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : _titleColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              onSelected: (_) => formNotifier.setCategory(cat),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationField(
    BuildContext context,
    MemoryFormState formState,
    MemoryFormNotifier formNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Location',
              style: TextStyle(
                color: _titleColor,
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (formState.locationName.isNotEmpty)
              TextButton(
                onPressed: () => formNotifier.clearLocation(),
                child: const Text('Clear', style: TextStyle(fontSize: 12.5)),
              ),
          ],
        ),
        const SizedBox(height: 8.0),
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
              formNotifier.setLocation(
                loc.name,
                lat: loc.latitude,
                lon: loc.longitude,
              );
            }
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(color: const Color(0xFFEADBCE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.place_outlined, color: _primaryOrange),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    formState.locationName.isNotEmpty
                        ? formState.locationName
                        : 'Tap to add location (GPS, Map, or Search)',
                    style: TextStyle(
                      color: formState.locationName.isNotEmpty
                          ? _titleColor
                          : const Color(0xFFB0A29A),
                      fontSize: 14.5,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14.0, color: Color(0xFF806A60)),
              ],
            ),
          ),
        ),
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
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: const Color(0xFFEADBCE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.favorite_rounded, color: Color(0xFFE91E63), size: 22),
              SizedBox(width: 10.0),
              Text(
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
    WidgetRef ref,
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
