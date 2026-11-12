import 'package:flutter/material.dart';
import '../../../onboarding/presentation/widgets/onboarding_logo.dart';
import '../widgets/settings_group_card.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('About Lifora'),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo & App Name
              const SizedBox(height: 12),
              const Center(child: OnboardingLogo(size: 64)),
              const SizedBox(height: 12),
              const Text(
                'Lifora',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _mainText,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Personal Memory Journal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _secondaryText,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE2CC).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'v1.0.0 (Build 1)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _primaryOrange,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Description Card
              SettingsGroupCard(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Our Philosophy',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _mainText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Lifora is an offline-first memory journal engineered to preserve life\'s most meaningful experiences privately and securely on your own device.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: _secondaryText,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          icon: Icons.folder_outlined,
                          text: 'Android Storage Access Framework (SAF) integration',
                        ),
                        const SizedBox(height: 8),
                        _buildFeatureItem(
                          icon: Icons.wifi_off_rounded,
                          text: '100% offline with zero cloud tracking or telemetry',
                        ),
                        const SizedBox(height: 8),
                        _buildFeatureItem(
                          icon: Icons.calendar_month_outlined,
                          text: 'Interactive memory timeline & multi-year "On This Day"',
                        ),
                        const SizedBox(height: 8),
                        _buildFeatureItem(
                          icon: Icons.map_outlined,
                          text: 'Geographic photo clustering & interactive maps',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Licenses
              SettingsGroupCard(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.article_outlined,
                      color: _primaryOrange,
                    ),
                    title: const Text(
                      'Open Source Licenses',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: _mainText,
                      ),
                    ),
                    subtitle: const Text(
                      'View third-party software notices and libraries',
                      style: TextStyle(fontSize: 12, color: _secondaryText),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: _secondaryText,
                    ),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: 'Lifora',
                        applicationVersion: '1.0.0',
                        applicationIcon: const OnboardingLogo(size: 48),
                        applicationLegalese:
                            '© 2026 Lifora. All rights reserved. Built with Flutter.',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Crafted with care in Sunset Orange',
                style: TextStyle(
                  fontSize: 12,
                  color: _secondaryText,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _primaryOrange),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _mainText,
            ),
          ),
        ),
      ],
    );
  }
}

