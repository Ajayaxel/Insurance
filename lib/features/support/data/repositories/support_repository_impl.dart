import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_remote_data_source.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;

  SupportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SupportTicketEntity>> getSupportTickets({required String token}) async {
    try {
      final models = await remoteDataSource.getSupportTickets(token: token);
      return models;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred while loading support tickets: ${e.toString()}',
      );
    }
  }

  @override
  Future<SupportTicketEntity> openSupportTicket({
    required String token,
    required String subject,
    required String message,
  }) async {
    try {
      final model = await remoteDataSource.openSupportTicket(
        token: token,
        subject: subject,
        message: message,
      );
      return model;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred while opening support ticket: ${e.toString()}',
      );
    }
  }
}
