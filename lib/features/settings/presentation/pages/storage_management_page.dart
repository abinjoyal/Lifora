import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../memories/presentation/providers/memory_provider.dart';
import '../../../storage/presentation/providers/storage_provider.dart';
import '../widgets/settings_group_card.dart';

class StorageManagementPage extends ConsumerWidget {
  const StorageManagementPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storageState = ref.watch(storageNotifierProvider);
    final storageNotifier = ref.read(storageNotifierProvider.notifier);
    final memoriesAsync = ref.watch(memoryListNotifierProvider);

    final isConnected = storageState.isConnected;
    final folderName = storageState.storageInfo?.folderName ?? 'Lifora';
    final treeUri = storageState.storageInfo?.treeUri ?? 'No folder connected';

    final memoryCount = memoriesAsync.maybeWhen(
      data: (list) => list.length,
      orElse: () => 0,
    );

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('Storage Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _mainText),
          tooltip: 'Back',
          onPressed: () => Navigator.maybePop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Storage Status Card
              SettingsGroupCard(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _peach.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.folder_special_rounded,
                            color: _primaryOrange,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                folderName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: _mainText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isConnected
                                    ? 'SAF Folder Connected'
                                    : 'Storage Disconnected',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isConnected
                                      ? Colors.green.shade700
                                      : Colors.red.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isConnected
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isConnected
                                  ? Colors.green.shade300
                                  : Colors.red.shade300,
                            ),
                          ),
                          child: Text(
                            isConnected ? 'ACTIVE' : 'OFFLINE',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: isConnected
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SAF Document Tree URI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _secondaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          treeUri,
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            color: _mainText,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_stories_rounded,
                              size: 16,
                              color: _primaryOrange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$memoryCount memories stored locally',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _mainText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. Storage Actions
              _buildSectionHeader('Storage Actions'),
              SettingsGroupCard(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.verified_outlined,
                      color: _primaryOrange,
                    ),
                    title: const Text(
                      'Verify Folder Access',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: _mainText,
                      ),
                    ),
                    subtitle: const Text(
                      'Test read/write permissions on the connected directory',
                      style: TextStyle(fontSize: 12, color: _secondaryText),
                    ),
                    onTap: () async {
                      final uri = storageState.storageInfo?.treeUri;
                      if (uri != null) {
                        try {
                          final valid = await ref.read(verifyStorageAccessUseCaseProvider)(uri);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  valid
                                      ? 'Storage folder access verified successfully.'
                                      : 'Storage access verification failed. Please reconnect.',
                                ),
                              ),
                            );
                          }
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Storage access verification failed. Please reconnect.'),
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: const Icon(
                      Icons.sync_rounded,
                      color: _primaryOrange,
                    ),
                    title: const Text(
                      'Reconnect Storage Folder',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: _mainText,
                      ),
                    ),
                    subtitle: const Text(
                      'Re-establish persisted Android permission for current folder',
                      style: TextStyle(fontSize: 12, color: _secondaryText),
                    ),
                    onTap: () async {
                      final uri = storageState.storageInfo?.treeUri;
                      if (uri != null) {
                        try {
                          await ref.read(reconnectStorageUseCaseProvider)(uri);
                          await storageNotifier.checkInitialStorage();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Storage folder reconnected successfully.',
                                ),
                              ),
                            );
                          }
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Failed to reconnect storage folder. Please choose folder again.',
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(
                      Icons.drive_file_move_outlined,
                      color: Colors.deepOrange.shade600,
                    ),
                    title: const Text(
                      'Change Storage Folder',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: _mainText,
                      ),
                    ),
                    subtitle: const Text(
                      'Select a new folder. Existing files in the old folder are preserved.',
                      style: TextStyle(fontSize: 12, color: _secondaryText),
                    ),
                    onTap: () => _confirmChangeFolder(context, storageNotifier),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. Information Box
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: _primaryOrange,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Lifora uses Android Storage Access Framework (SAF) so your memories reside safely in your device storage. If you reinstall Lifora, simply reconnect to the same folder to reload all your memories and photos.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: _secondaryText,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmChangeFolder(BuildContext context, StorageNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Storage Location?'),
        content: const Text(
          'Changing your folder will connect Lifora to a new directory. Your previous memories will remain in your old folder, but won\'t appear until you reconnect it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              notifier.selectParentFolder();
            },
            style: FilledButton.styleFrom(
              backgroundColor: _primaryOrange,
            ),
            child: const Text('Choose New Folder'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w700,
          color: _secondaryText,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

