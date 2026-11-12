import 'package:flutter/material.dart';
import '../../../../core/constants/asset_constants.dart';

class StorageIllustration extends StatelessWidget {
  const StorageIllustration({super.key, this.size = 130.0});

  final double size;

  static const Color _peachHalo = Color(0xFFFFE2CC);
  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Soft ambient peach halo
            Container(
              width: size * 1.1,
              height: size * 1.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _peachHalo.withValues(alpha: 0.7),
                    _peachHalo.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.2, 0.7, 1.0],
                ),
              ),
            ),

            // Storage Asset or Themed Vault Icon
            Image.asset(
              AssetConstants.storageReady,
              width: size * 0.85,
              height: size * 0.85,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) {
                return Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _primaryOrange.withValues(alpha: 0.15),
                        blurRadius: 16.0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.folder_special_rounded,
                    color: _primaryOrange,
                    size: 44,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
