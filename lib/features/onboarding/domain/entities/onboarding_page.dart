class OnboardingPageEntity {
  const OnboardingPageEntity({
    required this.index,
    required this.title,
    required this.description,
    required this.illustrationPath,
    required this.buttonText,
  });

  final int index;
  final String title;
  final String description;
  final String illustrationPath;
  final String buttonText;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingPageEntity &&
          runtimeType == other.runtimeType &&
          index == other.index &&
          title == other.title &&
          description == other.description &&
          illustrationPath == other.illustrationPath &&
          buttonText == other.buttonText;

  @override
  int get hashCode =>
      index.hashCode ^
      title.hashCode ^
      description.hashCode ^
      illustrationPath.hashCode ^
      buttonText.hashCode;
}
