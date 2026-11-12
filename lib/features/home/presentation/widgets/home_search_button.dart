import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';

class HomeSearchButton extends StatelessWidget {
  const HomeSearchButton({super.key});

  static const Color _iconColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search_rounded, color: _iconColor, size: 24),
      tooltip: 'Search memories',
      onPressed: () => context.push(RouteConstants.searchPath),
    );
  }
}
