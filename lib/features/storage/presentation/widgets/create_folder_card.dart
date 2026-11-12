import 'package:flutter/material.dart';
import 'storage_option_card.dart';

class CreateFolderCard extends StatelessWidget {
  const CreateFolderCard({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return StorageOptionCard(
      title: 'Create New Lifora Folder',
      description:
          'Create a dedicated folder to organize all your memories in one place.',
      buttonText: 'Create Lifora Folder',
      badgeText: 'Recommended',
      isHighlighted: true,
      isLoading: isLoading,
      icon: Icons.create_new_folder_rounded,
      onTap: onTap,
    );
  }
}
