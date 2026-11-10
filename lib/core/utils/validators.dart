import '../constants/app_constants.dart';

class Validators {
  Validators._();

  /// Validates memory title.
  static String? validateMemoryTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title cannot be empty.';
    }
    if (value.trim().length > AppConstants.maxTitleLength) {
      return 'Title cannot exceed ${AppConstants.maxTitleLength} characters.';
    }
    return null;
  }

  /// Validates memory description/content.
  static String? validateMemoryDescription(String? value) {
    if (value != null && value.length > AppConstants.maxDescriptionLength) {
      return 'Description cannot exceed ${AppConstants.maxDescriptionLength} characters.';
    }
    return null;
  }

  /// Validates geographic latitude (-90 to +90).
  static String? validateLatitude(double? latitude) {
    if (latitude == null) return null;
    if (latitude < -90.0 || latitude > 90.0) {
      return 'Latitude must be between -90 and 90 degrees.';
    }
    return null;
  }

  /// Validates geographic longitude (-180 to +180).
  static String? validateLongitude(double? longitude) {
    if (longitude == null) return null;
    if (longitude < -180.0 || longitude > 180.0) {
      return 'Longitude must be between -180 and 180 degrees.';
    }
    return null;
  }

  /// Validates a custom tag name.
  static String? validateTag(String? tag) {
    if (tag == null || tag.trim().isEmpty) {
      return 'Tag cannot be empty.';
    }
    if (tag.trim().length > 30) {
      return 'Tag cannot exceed 30 characters.';
    }
    if (tag.contains(RegExp(r'[\\/:*?"<>|,]'))) {
      return 'Tag contains invalid characters.';
    }
    return null;
  }
}
