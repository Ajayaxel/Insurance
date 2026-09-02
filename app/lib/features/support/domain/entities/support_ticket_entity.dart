import 'package:equatable/equatable.dart';

class SupportTicketEntity extends Equatable {
  final String id;
  final String subject;
  final String message;
  final String status;
  final String? createdAt;

  const SupportTicketEntity({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, subject, message, status, createdAt];
}
