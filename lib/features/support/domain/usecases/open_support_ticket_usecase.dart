import '../entities/support_ticket_entity.dart';
import '../repositories/support_repository.dart';

class OpenSupportTicketUseCase {
  final SupportRepository repository;

  OpenSupportTicketUseCase(this.repository);

  Future<SupportTicketEntity> call({
    required String token,
    required String subject,
    required String message,
  }) async {
    return await repository.openSupportTicket(
      token: token,
      subject: subject,
      message: message,
    );
  }
}
