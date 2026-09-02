import 'package:equatable/equatable.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

class FetchSupportTicketsEvent extends SupportEvent {
  final String token;

  const FetchSupportTicketsEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

class OpenSupportTicketEvent extends SupportEvent {
  final String token;
  final String subject;
  final String message;

  const OpenSupportTicketEvent({
    required this.token,
    required this.subject,
    required this.message,
  });

  @override
  List<Object?> get props => [token, subject, message];
}
