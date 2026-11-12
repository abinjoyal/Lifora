import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/storage_provider.dart';
import '../widgets/create_folder_card.dart';
import '../widgets/existing_folder_card.dart';
import '../widgets/storage_benefits.dart';
import '../widgets/storage_header.dart';
import '../widgets/storage_illustration.dart';

class StorageSetupPage extends ConsumerWidget {
  const StorageSetupPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _descColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storageNotifierProvider);
    final notifier = ref.read(storageNotifierProvider.notifier);

    // Listen for successful folder connection & transition to success screen
    ref.listen<StorageState>(storageNotifierProvider, (_, next) {
      if (next.isConnected) {
        context.go(RouteConstants.setupSuccessPath);
      }
    });

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        child: Column(
          children: [
            const StorageHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    const StorageIllustration(size: 110.0),
                    const SizedBox(height: 16.0),

                    // Heading
                    const Text(
                      'Choose Your Memory Folder',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _titleColor,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Description
                    const Text(
                      'Select where Lifora should securely keep your photos and memories.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _descColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Error Message (if any)
                    if (state.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: const Color(0xFFEF9A9A)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFC62828),
                              size: 20,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                state.errorMessage!,
                                style: const TextStyle(
                                  color: Color(0xFFC62828),
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 16,
                                color: Color(0xFFC62828),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => notifier.clearError(),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Option A: Create New Lifora Folder
                    CreateFolderCard(
                      isLoading:
                          state.isProcessing &&
                          (state.loadingMessage?.contains('Creating') ?? false),
                      onTap: () => notifier.handleCreateNewFolder(),
                    ),
                    const SizedBox(height: 16.0),

                    // Option B: Choose Existing Folder
                    ExistingFolderCard(
                      isLoading:
                          state.isProcessing &&
                          (state.loadingMessage?.contains('Opening') ?? false),
                      onTap: () => notifier.handleChooseExistingFolder(),
                    ),
                    const SizedBox(height: 24.0),

                    // Storage Benefits
                    const StorageBenefits(),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
