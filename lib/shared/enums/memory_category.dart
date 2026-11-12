import 'package:flutter/material.dart';

enum MemoryCategory {
  travel,
  family,
  friends,
  celebration,
  personal,
  other;

  String get displayName {
    return switch (this) {
      MemoryCategory.travel => 'Travel',
      MemoryCategory.family => 'Family',
      MemoryCategory.friends => 'Friends',
      MemoryCategory.celebration => 'Celebration',
      MemoryCategory.personal => 'Personal',
      MemoryCategory.other => 'Other',
    };
  }

  IconData get icon {
    return switch (this) {
      MemoryCategory.travel => Icons.flight_takeoff_rounded,
      MemoryCategory.family => Icons.family_restroom_rounded,
      MemoryCategory.friends => Icons.people_alt_rounded,
      MemoryCategory.celebration => Icons.celebration_rounded,
      MemoryCategory.personal => Icons.person_rounded,
      MemoryCategory.other => Icons.bookmark_border_rounded,
    };
  }
}
