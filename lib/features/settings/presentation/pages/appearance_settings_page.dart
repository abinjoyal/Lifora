import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_group_card.dart';

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsNotifierProvider);
    final settings = settingsState.settings;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('Appearance'),
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
              _buildSectionHeader('Theme Mode'),
              SettingsGroupCard(
                children: [
                  _buildThemeTile(
                    title: 'System Default',
                    subtitle: 'Automatically follow Android appearance',
                    mode: ThemeMode.system,
                    currentMode: settings.themeMode,
                    onTap: () => notifier.setThemeMode(ThemeMode.system),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildThemeTile(
                    title: 'Light (Sunset Orange)',
                    subtitle: 'Warm peach tones and minimal surfaces',
                    mode: ThemeMode.light,
                    currentMode: settings.themeMode,
                    onTap: () => notifier.setThemeMode(ThemeMode.light),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildThemeTile(
                    title: 'Dark',
                    subtitle: 'Deep dark background with subtle orange accents',
                    mode: ThemeMode.dark,
                    currentMode: settings.themeMode,
                    onTap: () => notifier.setThemeMode(ThemeMode.dark),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionHeader('Display Options'),
              SettingsGroupCard(
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Reduce Animations',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: _mainText,
                      ),
                    ),
                    subtitle: const Text(
                      'Minimize screen transitions and motion effects',
                      style: TextStyle(fontSize: 12, color: _secondaryText),
                    ),
                    value: settings.reduceAnimations,
                    activeThumbColor: _primaryOrange,
                    onChanged: (val) => notifier.setReduceAnimations(val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: const Text(
                      'Compact Layout',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: _mainText,
                      ),
                    ),
                    subtitle: const Text(
                      'Display more memories per screen',
                      style: TextStyle(fontSize: 12, color: _secondaryText),
                    ),
                    value: settings.compactLayout,
                    activeThumbColor: _primaryOrange,
                    onChanged: (val) => notifier.setCompactLayout(val),
                  ),
                ],
              ),
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

  Widget _buildThemeTile({
    required String title,
    required String subtitle,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onTap,
  }) {
    final isSelected = mode == currentMode;
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: _mainText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: _secondaryText),
      ),
      trailing: Icon(
        isSelected
            ? Icons.radio_button_checked_rounded
            : Icons.radio_button_off_rounded,
        color: isSelected ? _primaryOrange : const Color(0xFFC4B5A5),
      ),
      onTap: onTap,
    );
  }
}

