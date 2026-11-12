import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../shared/widgets/dialogs/confirmation_dialog.dart';
import '../../domain/entities/memory.dart';
import '../providers/memory_detail_provider.dart';
import '../providers/memory_provider.dart';
import '../widgets/memory_cover_image.dart';
import '../widgets/memory_date_badge.dart';
import '../widgets/memory_details_header.dart';
import '../widgets/memory_location_card.dart';
import '../widgets/memory_photo_gallery.dart';

class MemoryDetailsPage extends ConsumerWidget {
  const MemoryDetailsPage({super.key, required this.memoryId});

  final String memoryId;

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _bodyColor = Color(0xFF6A5750);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoryAsync = ref.watch(memoryDetailProvider(memoryId));

    return Scaffold(
      backgroundColor: _warmBackground,
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
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
          data: (memory) {
            if (memory == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_off_rounded,
                      color: Colors.grey,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text('Memory not found or has been removed.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Back to Timeline'),
                    ),
                  ],
                ),
              );
            }

            return _buildContent(context, ref, memory);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Memory memory) {
    return Column(
      children: [
        // Top action bar
        MemoryDetailsHeader(
          isFavorite: memory.isFavorite,
          onToggleFavorite: () async {
            await ref
                .read(memoryListNotifierProvider.notifier)
                .toggleFavorite(memory.id);
            ref.invalidate(memoryDetailProvider(memory.id));
          },
          onEdit: () async {
            await context.push(RouteConstants.memoryEditUrl(memory.id));
            ref.invalidate(memoryDetailProvider(memory.id));
          },
          onDelete: () => _confirmDelete(context, ref, memory),
          onShare: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sharing memory...')),
            );
          },
        ),

        // Scrollable body
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover Photo
                MemoryCoverImage(
                  imagePath: memory.coverPhoto?.localPath,
                  category: memory.category,
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date and Category
                      Row(
                        children: [
                          MemoryDateBadge(date: memory.date),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE2CC),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  memory.category.icon,
                                  size: 13,
                                  color: _primaryOrange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  memory.category.displayName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _primaryOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Title
                      Text(
                        memory.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: _titleColor,
                          letterSpacing: -0.4,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description / Journal note
                      if (memory.description != null &&
                          memory.description!.trim().isNotEmpty) ...[
                        Text(
                          memory.description!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: _bodyColor,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Location Card
                      if (memory.location != null) ...[
                        MemoryLocationCard(location: memory.location!),
                        const SizedBox(height: 24),
                      ],

                      // Photos Gallery
                      if (memory.photos.isNotEmpty) ...[
                        const Text(
                          'Photos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _titleColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        MemoryPhotoGallery(photos: memory.photos),
                        const SizedBox(height: 24),
                      ],

                      // Tags
                      if (memory.tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: memory.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3EBE3),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                '#$tag',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF806A60),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Memory memory,
  ) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Delete Memory?',
      message:
          'Are you sure you want to delete "${memory.title}"? This memory and its photos will be permanently removed.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      await ref.read(memoryListNotifierProvider.notifier).delete(memory.id);
      if (context.mounted) {
        context.pop();
      }
    }
  }
}

