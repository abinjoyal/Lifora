class SelectableItem<T> {
  const SelectableItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.isSelected = false,
    this.data,
  });

  final String id;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final T? data;

  SelectableItem<T> copyWith({
    String? id,
    String? title,
    String? subtitle,
    bool? isSelected,
    T? data,
  }) {
    return SelectableItem<T>(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isSelected: isSelected ?? this.isSelected,
      data: data ?? this.data,
    );
  }

  SelectableItem<T> toggleSelection() {
    return copyWith(isSelected: !isSelected);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectableItem<T> &&
          id == other.id &&
          title == other.title &&
          subtitle == other.subtitle &&
          isSelected == other.isSelected &&
          data == other.data;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      subtitle.hashCode ^
      isSelected.hashCode ^
      data.hashCode;

  @override
  String toString() =>
      'SelectableItem(id: $id, title: $title, isSelected: $isSelected)';
}
