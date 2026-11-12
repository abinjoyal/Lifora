import 'package:flutter/material.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({
    super.key,
    required this.imagePath,
    required this.pageIndex,
  });

  final String imagePath;
  final int pageIndex;

  // Soft peach background accent
  static const Color _peachHalo = Color(0xFFFFE2CC);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double illustrationHeight = (size.height * 0.35).clamp(220.0, 320.0);

    return SizedBox(
      height: illustrationHeight,
      width: double.infinity,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Soft decorative peach background halo matching the reference design
            Container(
              width: illustrationHeight * 0.95,
              height: illustrationHeight * 0.95,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _peachHalo.withValues(alpha: 0.65),
                    _peachHalo.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.2, 0.7, 1.0],
                ),
              ),
            ),

            // Illustration Image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) {
                  return _buildThemedFallback(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemedFallback(BuildContext context) {
    final theme = Theme.of(context);
    final IconData icon = switch (pageIndex) {
      0 => Icons.camera_enhance_rounded,
      1 => Icons.calendar_month_rounded,
      _ => Icons.folder_special_rounded,
    };

    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF47B45).withValues(alpha: 0.12),
            blurRadius: 20.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE2CC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Lifora Visual',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
