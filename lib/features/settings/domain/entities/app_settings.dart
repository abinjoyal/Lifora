import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.languageCode = 'en',
    this.reduceAnimations = false,
    this.compactLayout = false,
    required this.updatedAt,
  });

  final ThemeMode themeMode;
  final String languageCode;
  final bool reduceAnimations;
  final bool compactLayout;
  final DateTime updatedAt;

  AppSettings copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    bool? reduceAnimations,
    bool? compactLayout,
    DateTime? updatedAt,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      reduceAnimations: reduceAnimations ?? this.reduceAnimations,
      compactLayout: compactLayout ?? this.compactLayout,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          languageCode == other.languageCode &&
          reduceAnimations == other.reduceAnimations &&
          compactLayout == other.compactLayout &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      themeMode.hashCode ^
      languageCode.hashCode ^
      reduceAnimations.hashCode ^
      compactLayout.hashCode ^
      updatedAt.hashCode;
}

