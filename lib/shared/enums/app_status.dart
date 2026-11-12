enum AppStatus {
  initial,
  loading,
  success,
  error;

  bool get isInitial => this == AppStatus.initial;
  bool get isLoading => this == AppStatus.loading;
  bool get isSuccess => this == AppStatus.success;
  bool get isError => this == AppStatus.error;
}
