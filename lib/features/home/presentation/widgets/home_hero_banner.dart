import 'package:flutter/material.dart';

class HomeHeroBanner extends StatelessWidget {
  const HomeHeroBanner({super.key});

  static const Color _titleColor = Color(0xFF38251F);
  static const Color _peachGradStart = Color(0xFFFFE2CC);
  static const Color _peachGradEnd = Color(0xFFFFF6ED);
  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 145.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        gradient: const LinearGradient(
          colors: [_peachGradStart, _peachGradEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _primaryOrange.withValues(alpha: 0.08),
            blurRadius: 16.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          // Background ambient light decoration
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _primaryOrange.withValues(alpha: 0.12),
              ),
            ),
          ),

          // Content Layout
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                // Left: Text description
                const Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Memory Space',
                        style: TextStyle(
                          color: _titleColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        'Every moment, trip, and story safely kept in your local vault.',
                        style: TextStyle(
                          color: Color(0xFF806A60),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right: Floating Polaroid Cards Graphic
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Back card tilted left
                        Transform.rotate(
                          angle: -0.16,
                          child: _buildPolaroidCard(
                            color: const Color(0xFFFFD1B3),
                            icon: Icons.beach_access_rounded,
                          ),
                        ),
                        // Front card tilted right
                        Transform.rotate(
                          angle: 0.12,
                          child: _buildPolaroidCard(
                            color: Colors.white,
                            icon: Icons.photo_camera_rounded,
                            isFront: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolaroidCard({
    required Color color,
    required IconData icon,
    bool isFront = false,
  }) {
    return Container(
      width: 60,
      height: 74,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isFront ? 0.15 : 0.08),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF47B45).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Center(
                child: Icon(icon, color: const Color(0xFFF47B45), size: 20),
              ),
            ),
          ),
          const SizedBox(height: 6.0),
          Container(
            width: 24,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
