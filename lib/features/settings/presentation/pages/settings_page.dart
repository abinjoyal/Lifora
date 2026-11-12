import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/settings_provider.dart';
import '../widgets/reset_settings_dialog.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/settings_tile.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsNotifierProvider);
    final settings = settingsState.settings;

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('Settings'),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group A: Preferences
              _buildSectionHeader('Preferences'),
              SettingsGroupCard(
                children: [
                  SettingsTile(
                    icon: Icons.palette_outlined,
                    title: 'Appearance',
                    subtitle: 'Theme, animations and display density',
                    trailing: Text(
                      _getThemeLabel(settings.themeMode),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _primaryOrange,
                      ),
                    ),
                    onTap: () =>
                        context.push(RouteConstants.settingsAppearancePath),
                  ),
                  const Divider(height: 1, indent: 56),
                  SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle: 'Reminders, "On This Day" and daily prompts',
                    onTap: () =>
                        context.push(RouteConstants.notificationSettingsPath),
                  ),
                  const Divider(height: 1, indent: 56),
                  SettingsTile(
                    icon: Icons.translate_rounded,
                    title: 'Language',
                    subtitle: 'App display language',
                    trailing: Text(
                      settings.languageCode == 'ta' ? 'தமிழ்' : 'English',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _primaryOrange,
                      ),
                    ),
                    onTap: () =>
                        context.push(RouteConstants.settingsLanguagePath),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Group B: Storage & Privacy
              _buildSectionHeader('Storage & Privacy'),
              SettingsGroupCard(
                children: [
                  SettingsTile(
                    icon: Icons.folder_outlined,
                    title: 'Storage Management',
                    subtitle: 'SAF folder location and health checks',
                    onTap: () =>
                        context.push(RouteConstants.settingsStoragePath),
                  ),
                  const Divider(height: 1, indent: 56),
                  SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Privacy & Security',
                    subtitle: 'Offline data, previews and encryption details',
                    onTap: () =>
                        context.push(RouteConstants.settingsPrivacyPath),
                  ),
                  const Divider(height: 1, indent: 56),
                  SettingsTile(
                    icon: Icons.download_outlined,
                    title: 'Backup & Export',
                    subtitle: 'Export memory metadata and journal entries',
                    onTap: () =>
                        context.push(RouteConstants.settingsBackupPath),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Group C: About & Support
              _buildSectionHeader('About & General'),
              SettingsGroupCard(
                children: [
                  SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About Lifora',
                    subtitle: 'Version 1.0.0, architecture & licenses',
                    onTap: () => context.push(RouteConstants.settingsAboutPath),
                  ),
                  const Divider(height: 1, indent: 56),
                  SettingsTile(
                    icon: Icons.restore_rounded,
                    title: 'Reset Preferences',
                    subtitle: 'Restore theme and default display options',
                    iconColor: Colors.deepOrange,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ResetSettingsDialog(
                          onConfirm: () {
                            ref
                                .read(settingsNotifierProvider.notifier)
                                .resetAllSettings();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'App preferences restored to default.',
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
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

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}
