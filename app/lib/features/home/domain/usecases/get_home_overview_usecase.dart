import '../entities/home_overview_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeOverviewUseCase {
  final HomeRepository repository;

  GetHomeOverviewUseCase(this.repository);

  Future<HomeOverviewEntity> call({required String token}) async {
    return await repository.getHomeOverview(token: token);
  }
}
