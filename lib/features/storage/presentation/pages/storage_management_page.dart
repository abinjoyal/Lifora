import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/storage_provider.dart';
import '../widgets/selected_folder_card.dart';
import '../widgets/storage_benefits.dart';

class StorageManagementPage extends ConsumerWidget {
  const StorageManagementPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storageNotifierProvider);
    final storageInfo = state.storageInfo;

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(title: const Text('Storage Vault'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (storageInfo != null) ...[
                const Text(
                  'Connected Storage',
                  style: TextStyle(
                    color: _titleColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12.0),
                SelectedFolderCard(storageInfo: storageInfo),
                const SizedBox(height: 24.0),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: const Color(0xFFEADBCE)),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.folder_off_outlined,
                        size: 48,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No Storage Folder Connected',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Connect a folder to begin saving your memories safely.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.go(RouteConstants.storageSetupPath),
                        child: const Text('Connect Storage Now'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
              ],

              const Text(
                'Data Security & Offline Guarantee',
                style: TextStyle(
                  color: _titleColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              const StorageBenefits(),
              const SizedBox(height: 32.0),

              // Change Folder Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: _primaryOrange),
                ),
                icon: const Icon(Icons.swap_horiz_rounded),
                label: const Text('Change or Reconnect Folder'),
                onPressed: () => context.go(RouteConstants.storageSetupPath),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
