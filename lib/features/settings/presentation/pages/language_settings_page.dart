import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_group_card.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsNotifierProvider);
    final selectedLanguage = settingsState.settings.languageCode;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('Language'),
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
              _buildSectionHeader('Supported Languages'),
              SettingsGroupCard(
                children: [
                  _buildLanguageTile(
                    title: 'English',
                    subtitle: 'App interface in English',
                    languageCode: 'en',
                    currentLanguage: selectedLanguage,
                    onTap: () => notifier.setLanguage('en'),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildLanguageTile(
                    title: 'தமிழ் (Tamil)',
                    subtitle: 'பயன்பாட்டு இடைமுகம் தமிழில்',
                    languageCode: 'ta',
                    currentLanguage: selectedLanguage,
                    onTap: () => notifier.setLanguage('ta'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: _primaryOrange,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Changing app language updates interface text only. Your memory titles, descriptions and photos remain preserved in their original language.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: _secondaryText,
                          height: 1.35,
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

  Widget _buildLanguageTile({
    required String title,
    required String subtitle,
    required String languageCode,
    required String currentLanguage,
    required VoidCallback onTap,
  }) {
    final isSelected = languageCode == currentLanguage;
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
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

