import 'package:flutter/material.dart';

class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    required this.onLocateUser,
    required this.isLocatingUser,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onFitAllMarkers,
  });

  final VoidCallback onLocateUser;
  final bool isLocatingUser;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onFitAllMarkers;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // My Location Button
        _buildButton(
          onTap: onLocateUser,
          tooltip: 'My Location',
          child: isLocatingUser
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryOrange),
                  ),
                )
              : const Icon(
                  Icons.my_location_rounded,
                  color: _primaryOrange,
                  size: 22,
                ),
        ),
        const SizedBox(height: 10),

        // Fit All Markers
        _buildButton(
          onTap: onFitAllMarkers,
          tooltip: 'Fit All Memories',
          child: const Icon(
            Icons.center_focus_strong_rounded,
            color: _mainText,
            size: 20,
          ),
        ),
        const SizedBox(height: 10),

        // Zoom In & Out Combined Card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.add_rounded, color: _mainText),
                onPressed: onZoomIn,
                tooltip: 'Zoom In',
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              ),
              Container(
                height: 1,
                width: 28,
                color: const Color(0xFFEADBCE),
              ),
              IconButton(
                icon: const Icon(Icons.remove_rounded, color: _mainText),
                onPressed: onZoomOut,
                tooltip: 'Zoom Out',
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required VoidCallback onTap,
    required String tooltip,
    required Widget child,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.0),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.0),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

