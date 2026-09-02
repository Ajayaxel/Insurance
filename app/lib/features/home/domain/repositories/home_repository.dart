import '../entities/home_overview_entity.dart';

abstract class HomeRepository {
  /// Fetches policyholder dashboard overview metrics from GET /portal/me/insurance/overview
  Future<HomeOverviewEntity> getHomeOverview({required String token});
}
