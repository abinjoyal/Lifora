import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../enums/memory_category.dart';
import '../../extensions/date_extensions.dart';
import 'app_card.dart';

class MemoryCard extends StatelessWidget {
  const MemoryCard({
    super.key,
    required this.title,
    required this.date,
    this.description,
    this.imagePath,
    this.locationName,
    this.category,
    this.tags = const [],
    this.onTap,
  });

  final String title;
  final DateTime date;
  final String? description;
  final String? imagePath;
  final String? locationName;
  final MemoryCategory? category;
  final List<String> tags;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imagePath != null && imagePath!.isNotEmpty)
            _buildThumbnail(context)
          else
            _buildCategoryBanner(context),
          Padding(
            padding: AppDimensions.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: AppDimensions.iconSmall,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppDimensions.space6),
                    Text(
                      date.toReadableDate(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (locationName != null && locationName!.isNotEmpty) ...[
                      const SizedBox(width: AppDimensions.space12),
                      Icon(
                        Icons.place_outlined,
                        size: AppDimensions.iconSmall,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space4),
                      Expanded(
                        child: Text(
                          locationName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.space6),
                  Text(
                    description!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.75,
                      ),
                    ),
                  ),
                ],
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.space12),
                  Wrap(
                    spacing: AppDimensions.space6,
                    runSpacing: AppDimensions.space4,
                    children: tags.take(3).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.4,
                          ),
                          borderRadius: AppDimensions.borderRadiusSmall,
                        ),
                        child: Text(
                          '#$tag',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildCategoryBanner(context),
      ),
    );
  }

  Widget _buildCategoryBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 60,
      width: double.infinity,
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(
            category?.icon ?? Icons.auto_stories_outlined,
            color: theme.colorScheme.primary,
            size: AppDimensions.iconMedium,
          ),
          const SizedBox(width: AppDimensions.space8),
          Text(
            category?.displayName ?? 'Memory',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
