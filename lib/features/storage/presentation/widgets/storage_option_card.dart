import 'package:flutter/material.dart';

class StorageOptionCard extends StatelessWidget {
  const StorageOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
    required this.icon,
    this.badgeText,
    this.isHighlighted = false,
    this.isLoading = false,
  });

  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;
  final IconData icon;
  final String? badgeText;
  final bool isHighlighted;
  final bool isLoading;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _darkOrange = Color(0xFFB94E2D);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _descColor = Color(0xFF806A60);
  static const Color _peachBg = Color(0xFFFFE2CC);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: isHighlighted ? _primaryOrange : const Color(0xFFEADBCE),
          width: isHighlighted ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isHighlighted
                ? _primaryOrange.withValues(alpha: 0.12)
                : const Color(0xFF38251F).withValues(alpha: 0.05),
            blurRadius: 14.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isHighlighted ? _primaryOrange : _peachBg,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  icon,
                  color: isHighlighted ? Colors.white : _primaryOrange,
                  size: 24,
                ),
              ),

              // Optional "Recommended" Badge
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: _peachBg,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    badgeText!,
                    style: const TextStyle(
                      color: _darkOrange,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Title
          Text(
            title,
            style: const TextStyle(
              color: _titleColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6.0),

          // Description
          Text(
            description,
            style: const TextStyle(
              color: _descColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18.0),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 46.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isHighlighted ? _primaryOrange : Colors.white,
                foregroundColor: isHighlighted ? Colors.white : _primaryOrange,
                side: isHighlighted
                    ? BorderSide.none
                    : const BorderSide(color: _primaryOrange, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: isHighlighted ? 2.0 : 0.0,
              ),
              onPressed: isLoading ? null : onTap,
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isHighlighted ? Colors.white : _primaryOrange,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonText,
                          style: TextStyle(
                            color: isHighlighted
                                ? Colors.white
                                : _primaryOrange,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18.0,
                          color: isHighlighted ? Colors.white : _primaryOrange,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
