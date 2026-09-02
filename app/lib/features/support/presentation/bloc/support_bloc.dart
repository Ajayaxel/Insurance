import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_support_tickets_usecase.dart';
import '../../domain/usecases/open_support_ticket_usecase.dart';
import 'support_event.dart';
import 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  final GetSupportTicketsUseCase getSupportTicketsUseCase;
  final OpenSupportTicketUseCase openSupportTicketUseCase;

  SupportBloc({
    required this.getSupportTicketsUseCase,
    required this.openSupportTicketUseCase,
  }) : super(SupportInitialState()) {
    on<FetchSupportTicketsEvent>(_onFetchSupportTickets);
    on<OpenSupportTicketEvent>(_onOpenSupportTicket);
  }

  Future<void> _onFetchSupportTickets(
    FetchSupportTicketsEvent event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoadingState());
    try {
      final tickets = await getSupportTicketsUseCase(token: event.token);
      emit(SupportTicketsLoadedState(tickets: tickets));
    } catch (e) {
      emit(SupportErrorState(
        e.toString().replaceAll('Exception: ', '').replaceAll('ServerException: ', ''),
      ));
    }
  }

  Future<void> _onOpenSupportTicket(
    OpenSupportTicketEvent event,
    Emitter<SupportState> emit,
  ) async {
    emit(SupportLoadingState());
    try {
      final ticket = await openSupportTicketUseCase(
        token: event.token,
        subject: event.subject,
        message: event.message,
      );
      emit(SupportTicketCreatedSuccessState(
        ticket: ticket,
        message: 'Support ticket created successfully!',
      ));
    } catch (e) {
      emit(SupportErrorState(
        e.toString().replaceAll('Exception: ', '').replaceAll('ServerException: ', ''),
      ));
    }
  }
}
