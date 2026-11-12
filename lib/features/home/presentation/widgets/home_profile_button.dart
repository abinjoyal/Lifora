import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';

class HomeProfileButton extends StatelessWidget {
  const HomeProfileButton({super.key});

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peachBg = Color(0xFFFFE2CC);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.0),
      onTap: () => context.push(RouteConstants.profilePath),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _peachBg,
          shape: BoxShape.circle,
          border: Border.all(
            color: _primaryOrange.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: const Icon(
          Icons.person_rounded,
          color: _primaryOrange,
          size: 20,
        ),
      ),
    );
  }
}
