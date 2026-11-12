import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../memories/domain/entities/memory.dart';

class CalendarMemoryCard extends StatelessWidget {
  const CalendarMemoryCard({
    super.key,
    required this.memory,
  });

  final Memory memory;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _borderColor = Color(0xFFEADBCE);

  @override
  Widget build(BuildContext context) {
    final cover = memory.coverPhoto;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: _borderColor, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: _mainText.withValues(alpha: 0.04),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.push(RouteConstants.memoryDetailsUrl(memory.id));
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Square Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: SizedBox(
                      width: 76,
                      height: 76,
                      child: cover?.localPath != null &&
                              File(cover!.localPath!).existsSync()
                          ? Image.file(
                              File(cover.localPath!),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: _peach.withValues(alpha: 0.6),
                              child: Icon(
                                memory.category.icon,
                                size: 30,
                                color: _primaryOrange,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14.0),

                  // Middle Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          memory.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                            color: _mainText,
                          ),
                        ),
                        const SizedBox(height: 4.0),

                        // Location if present
                        if (memory.location != null) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                size: 13.0,
                                color: _primaryOrange,
                              ),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: Text(
                                  memory.location!.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: _secondaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                        ],

                        // Tags & Badges
                        Row(
                          children: [
                            // Category Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.5,
                              ),
                              decoration: BoxDecoration(
                                color: _peach.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    memory.category.icon,
                                    size: 11.0,
                                    color: _primaryOrange,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    memory.category.displayName,
                                    style: const TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                      color: _primaryOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8.0),

                            // Photo count badge if > 0
                            if (memory.photos.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                  vertical: 2.5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.photo_library_outlined,
                                      size: 11.0,
                                      color: _secondaryText,
                                    ),
                                    const SizedBox(width: 3.0),
                                    Text(
                                      '${memory.photos.length}',
                                      style: const TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w600,
                                        color: _secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Right Chevron
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFC4B2A8),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

