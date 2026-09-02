import '../entities/support_ticket_entity.dart';

abstract class SupportRepository {
  /// Fetches list of support tickets
  Future<List<SupportTicketEntity>> getSupportTickets({required String token});

  /// Opens a new support ticket
  Future<SupportTicketEntity> openSupportTicket({
    required String token,
    required String subject,
    required String message,
  });
}
