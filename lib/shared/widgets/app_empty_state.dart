import 'package:flutter/material.dart';
import '../../core/theme/app_dimensions.dart';
import 'buttons/primary_button.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.auto_stories_outlined,
    this.imageAssetPath,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String description;
  final IconData icon;
  final String? imageAssetPath;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space32,
          vertical: AppDimensions.space24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (imageAssetPath != null && imageAssetPath!.isNotEmpty)
              Image.asset(
                imageAssetPath!,
                width: 180,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => _buildIconPlaceholder(context),
              )
            else
              _buildIconPlaceholder(context),
            const SizedBox(height: AppDimensions.space24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.space32),
              PrimaryButton(
                text: actionLabel!,
                width: 220,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIconPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 48, color: theme.colorScheme.primary),
    );
  }
}
