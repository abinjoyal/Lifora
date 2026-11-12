extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  String get capitalizeFirst {
    if (trim().isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes each word in a space-delimited string.
  String get capitalizeWords {
    if (trim().isEmpty) return this;
    return split(' ')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  /// Returns null if the string is empty or contains only whitespace.
  String? get nullIfEmpty {
    return trim().isEmpty ? null : this;
  }

  /// Truncates string to [maxLength] appending an ellipsis if exceeded.
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Checks if string is a valid file extension.
  bool get isValidExtension => startsWith('.') && length > 1;
}

extension NullableStringExtensions on String? {
  /// Checks whether nullable string is null or whitespace only.
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// Checks whether nullable string has actual non-whitespace content.
  bool get isNotNullOrBlank => !isNullOrBlank;
}
