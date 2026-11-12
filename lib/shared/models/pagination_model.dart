class PaginationModel {
  const PaginationModel({
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
  });

  final int currentPage;
  final int pageSize;
  final int totalItems;

  int get totalPages => (totalItems / pageSize).ceil();

  bool get hasNextPage => currentPage < totalPages;

  bool get hasPreviousPage => currentPage > 1;

  bool get isFirstPage => currentPage == 1;

  bool get isLastPage => currentPage >= totalPages;

  PaginationModel copyWith({int? currentPage, int? pageSize, int? totalItems}) {
    return PaginationModel(
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  PaginationModel nextPage() {
    if (!hasNextPage) return this;
    return copyWith(currentPage: currentPage + 1);
  }

  PaginationModel previousPage() {
    if (!hasPreviousPage) return this;
    return copyWith(currentPage: currentPage - 1);
  }

  static const PaginationModel initial = PaginationModel(
    currentPage: 1,
    pageSize: 20,
    totalItems: 0,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationModel &&
          currentPage == other.currentPage &&
          pageSize == other.pageSize &&
          totalItems == other.totalItems;

  @override
  int get hashCode =>
      currentPage.hashCode ^ pageSize.hashCode ^ totalItems.hashCode;

  @override
  String toString() =>
      'PaginationModel(currentPage: $currentPage, pageSize: $pageSize, totalItems: $totalItems, totalPages: $totalPages)';
}
