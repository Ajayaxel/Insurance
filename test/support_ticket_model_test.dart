import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/support/data/models/support_ticket_model.dart';

void main() {
  group('SupportTicketModel parsing tests', () {
    test('should parse support ticket JSON payload correctly', () {
      final jsonMap = {
        "id": "tkt_501",
        "subject": "Update my registered mobile number",
        "message": "Please change it to 98460 12345.",
        "status": "OPEN",
        "createdAt": "2026-09-01T00:00:00.000Z"
      };

      final model = SupportTicketModel.fromJson(jsonMap);

      expect(model.id, 'tkt_501');
      expect(model.subject, 'Update my registered mobile number');
      expect(model.message, 'Please change it to 98460 12345.');
      expect(model.status, 'OPEN');
    });

    test('should serialize SupportTicketModel to JSON correctly', () {
      const model = SupportTicketModel(
        id: 'tkt_502',
        subject: 'Change address',
        message: 'Please update address to Kochi.',
        status: 'PENDING',
      );

      final json = model.toJson();

      expect(json['id'], 'tkt_502');
      expect(json['subject'], 'Change address');
      expect(json['status'], 'PENDING');
    });
  });
}
