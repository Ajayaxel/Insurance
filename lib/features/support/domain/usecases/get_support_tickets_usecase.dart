import '../entities/support_ticket_entity.dart';
import '../repositories/support_repository.dart';

class GetSupportTicketsUseCase {
  final SupportRepository repository;

  GetSupportTicketsUseCase(this.repository);

  Future<List<SupportTicketEntity>> call({required String token}) async {
    return await repository.getSupportTickets(token: token);
  }
}
