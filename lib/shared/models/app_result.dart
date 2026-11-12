sealed class AppResult<T, E> {
  const AppResult();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T? get dataOrNull => switch (this) {
    Success(data: final d) => d,
    Failure() => null,
  };

  E? get errorOrNull => switch (this) {
    Success() => null,
    Failure(error: final e) => e,
  };

  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  }) {
    return switch (this) {
      Success(data: final d) => success(d),
      Failure(error: final e) => failure(e),
    };
  }

  AppResult<R, E> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(data: final d) => Success(transform(d)),
      Failure(error: final e) => Failure(e),
    };
  }
}

final class Success<T, E> extends AppResult<T, E> {
  const Success(this.data);

  final T data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T, E> && other.data == data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success(data: $data)';
}

final class Failure<T, E> extends AppResult<T, E> {
  const Failure(this.error);

  final E error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Failure<T, E> && other.error == error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure(error: $error)';
}
