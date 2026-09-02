import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/policies/data/models/policy_model.dart';

void main() {
  group('PolicyModel parsing tests', () {
    test('should parse individual policy JSON correctly', () {
      final jsonResponse = {
        "id": "pol_9981",
        "policyNumber": "POL-2026-8849",
        "type": "HEALTH",
        "status": "ACTIVE",
        "planName": "Comprehensive Family Health Cover",
        "insuredAmountInr": 500000,
        "premiumAmountInr": 18500,
        "startDate": "2026-01-01",
        "endDate": "2026-12-31",
        "insurerName": "Star Health Insurance"
      };

      final model = PolicyModel.fromJson(jsonResponse);

      expect(model.id, 'pol_9981');
      expect(model.policyNumber, 'POL-2026-8849');
      expect(model.type, 'HEALTH');
      expect(model.status, 'ACTIVE');
      expect(model.isActive, isTrue);
      expect(model.planName, 'Comprehensive Family Health Cover');
      expect(model.insuredAmountInr, 500000);
      expect(model.premiumAmountInr, 18500);
      expect(model.startDate, '2026-01-01');
      expect(model.endDate, '2026-12-31');
      expect(model.insurerName, 'Star Health Insurance');
    });

    test('should serialize PolicyModel to JSON correctly', () {
      const model = PolicyModel(
        id: 'pol_100',
        policyNumber: 'POL-100-XYZ',
        type: 'MOTOR',
        status: 'EXPIRED',
        planName: 'Car Insurance',
      );

      final jsonMap = model.toJson();

      expect(jsonMap['id'], 'pol_100');
      expect(jsonMap['policyNumber'], 'POL-100-XYZ');
      expect(jsonMap['type'], 'MOTOR');
      expect(jsonMap['status'], 'EXPIRED');
      expect(jsonMap['planName'], 'Car Insurance');
    });
  });
}
