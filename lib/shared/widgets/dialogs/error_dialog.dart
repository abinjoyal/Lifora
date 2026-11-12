import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.message,
    this.title = 'Something Went Wrong',
    this.details,
    this.buttonLabel = 'Dismiss',
  });

  final String title;
  final String message;
  final String? details;
  final String buttonLabel;

  static Future<void> show(
    BuildContext context, {
    required String message,
    String title = 'Something Went Wrong',
    String? details,
    String buttonLabel = 'Dismiss',
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        details: details,
        buttonLabel: buttonLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: AppDimensions.borderRadiusLarge,
      ),
      contentPadding: AppDimensions.dialogPadding,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.space8),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: theme.colorScheme.error,
              size: AppDimensions.iconMedium,
            ),
          ),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
          if (details != null && details!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.space12),
            Container(
              padding: const EdgeInsets.all(AppDimensions.space8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.4,
                ),
                borderRadius: AppDimensions.borderRadiusSmall,
              ),
              child: Text(
                details!,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonLabel),
        ),
      ],
    );
  }
}
