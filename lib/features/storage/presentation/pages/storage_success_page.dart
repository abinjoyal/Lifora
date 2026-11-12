import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/storage_provider.dart';
import '../widgets/selected_folder_card.dart';
import '../widgets/storage_action_button.dart';
import '../widgets/storage_header.dart';
import '../widgets/storage_illustration.dart';

class StorageSuccessPage extends ConsumerWidget {
  const StorageSuccessPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _descColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storageNotifierProvider);
    final storageInfo = state.storageInfo;

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        child: Column(
          children: [
            const StorageHeader(stepLabel: 'Complete'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12.0),
                    const StorageIllustration(size: 130.0),
                    const SizedBox(height: 20.0),

                    // Title
                    const Text(
                      'Your Memory Space Is Ready!',
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
                      'Your Lifora folder is connected. Start saving your special moments.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _descColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28.0),

                    // Selected Folder Summary Card
                    if (storageInfo != null)
                      SelectedFolderCard(storageInfo: storageInfo),

                    const SizedBox(height: 36.0),

                    // Continue Action Button
                    StorageActionButton(
                      text: 'Continue to Lifora',
                      onPressed: () {
                        context.go(RouteConstants.homePath);
                      },
                    ),
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
