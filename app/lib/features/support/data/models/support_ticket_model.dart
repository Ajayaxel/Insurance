import '../../domain/entities/support_ticket_entity.dart';

class SupportTicketModel extends SupportTicketEntity {
  const SupportTicketModel({
    required super.id,
    required super.subject,
    required super.message,
    required super.status,
    super.createdAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: (json['id'] ?? json['_id'] ?? json['ticketId'] ?? '').toString(),
      subject: (json['subject'] ?? json['title'] ?? '').toString(),
      message: (json['message'] ?? json['description'] ?? '').toString(),
      status: (json['status'] ?? 'OPEN').toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'message': message,
      'status': status,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}
