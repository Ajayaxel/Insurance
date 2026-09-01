import 'package:equatable/equatable.dart';
import '../../domain/entities/support_ticket_entity.dart';

abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object?> get props => [];
}

class SupportInitialState extends SupportState {}

class SupportLoadingState extends SupportState {}

class SupportTicketsLoadedState extends SupportState {
  final List<SupportTicketEntity> tickets;

  const SupportTicketsLoadedState({required this.tickets});

  @override
  List<Object?> get props => [tickets];
}

class SupportTicketCreatedSuccessState extends SupportState {
  final SupportTicketEntity ticket;
  final String message;

  const SupportTicketCreatedSuccessState({
    required this.ticket,
    required this.message,
  });

  @override
  List<Object?> get props => [ticket, message];
}

class SupportErrorState extends SupportState {
  final String message;

  const SupportErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
