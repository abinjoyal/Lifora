import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../notifications/presentation/providers/notification_settings_provider.dart';
import '../widgets/settings_group_card.dart';

class PrivacySettingsPage extends ConsumerWidget {
  const PrivacySettingsPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSettingsState =
        ref.watch(notificationSettingsNotifierProvider);
    final notificationSettings = notificationSettingsState.settings;
    final notificationSettingsNotifier =
        ref.read(notificationSettingsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('Privacy & Security'),
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
              _buildSectionHeader('Notification Privacy'),
              SettingsGroupCard(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Hide Notification Previews',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: _mainText,
                      ),
                    ),
                    subtitle: const Text(
                      'Replaces personal memory titles and details with generic messages on the lock screen',
                      style: TextStyle(fontSize: 12, color: _secondaryText),
                    ),
                    value: notificationSettings.privacyModeEnabled,
                    activeThumbColor: _primaryOrange,
                    onChanged: (val) {
                      notificationSettingsNotifier.updateSettings(
                        notificationSettings.copyWith(
                          privacyModeEnabled: val,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('Privacy Architecture'),
              Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPillarRow(
                      icon: Icons.wifi_off_rounded,
                      title: '100% Offline by Design',
                      description:
                          'Lifora runs locally on your Android device. It never uploads your personal journals, photos, or audio recordings to any remote server.',
                    ),
                    const Divider(height: 24),
                    _buildPillarRow(
                      icon: Icons.account_circle_outlined,
                      title: 'No Cloud Account Required',
                      description:
                          'You do not need to create an account, log in, or provide an email address. Your identity and journal belong entirely to you.',
                    ),
                    const Divider(height: 24),
                    _buildPillarRow(
                      icon: Icons.folder_zip_outlined,
                      title: 'Transparent File System',
                      description:
                          'Your memories are saved as human-readable JSON files and original photos inside your chosen device folder via Android Storage Access Framework.',
                    ),
                    const Divider(height: 24),
                    _buildPillarRow(
                      icon: Icons.analytics_outlined,
                      title: 'Zero Third-Party Trackers',
                      description:
                          'Lifora includes no telemetry, behavioral tracking, or advertising SDKs.',
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

  Widget _buildPillarRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE2CC).withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: _primaryOrange),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: _mainText,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: _secondaryText,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
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

