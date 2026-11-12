import 'package:flutter/material.dart';
import 'storage_option_card.dart';

class ExistingFolderCard extends StatelessWidget {
  const ExistingFolderCard({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return StorageOptionCard(
      title: 'Choose Existing Folder',
      description:
          'Already have a folder? Select it and let Lifora organize your memories there.',
      buttonText: 'Choose Existing Folder',
      isHighlighted: false,
      isLoading: isLoading,
      icon: Icons.folder_open_rounded,
      onTap: onTap,
    );
  }
}
