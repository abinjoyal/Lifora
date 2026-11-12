import '../entities/home_summary.dart';
import '../repositories/home_repository.dart';

class GetHomeSummary {
  const GetHomeSummary(this._repository);

  final HomeRepository _repository;

  Future<HomeSummary> call() {
    return _repository.getHomeSummary();
  }
}
