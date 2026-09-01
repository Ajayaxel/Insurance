import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/home_overview_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HomeOverviewEntity> getHomeOverview({required String token}) async {
    try {
      final model = await remoteDataSource.getHomeOverview(token: token);
      return model;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred while loading dashboard overview: ${e.toString()}',
      );
    }
  }
}
