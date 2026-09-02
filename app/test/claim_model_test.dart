import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/claims/data/models/claim_model.dart';

void main() {
  group('ClaimModel parsing tests', () {
    test('should parse claim JSON payload correctly', () {
      final jsonMap = {
        "id": "clm_101",
        "policyId": "pol_55",
        "status": "SUBMITTED",
        "incidentDate": "2026-08-01",
        "description": "Rear-ended at a signal; bumper and tail lamp damaged.",
        "estimatedAmountInr": 45000,
        "documents": [
          {
            "key": "fir_copy",
            "url": "https://example.com/fir.pdf"
          }
        ]
      };

      final model = ClaimModel.fromJson(jsonMap);

      expect(model.id, 'clm_101');
      expect(model.policyId, 'pol_55');
      expect(model.status, 'SUBMITTED');
      expect(model.incidentDate, '2026-08-01');
      expect(model.estimatedAmountInr, 45000);
      expect(model.documents.length, 1);
      expect(model.documents.first.key, 'fir_copy');
      expect(model.documents.first.url, 'https://example.com/fir.pdf');
    });

    test('should serialize ClaimModel to JSON correctly', () {
      const model = ClaimModel(
        id: 'clm_102',
        status: 'UNDER_REVIEW',
        incidentDate: '2026-08-02',
        description: 'Test claim',
        estimatedAmountInr: 10000,
        documents: [
          ClaimDocumentModel(key: 'bills', url: 'https://example.com/bill.pdf'),
        ],
      );

      final json = model.toJson();

      expect(json['id'], 'clm_102');
      expect(json['estimatedAmountInr'], 10000);
      expect((json['documents'] as List).length, 1);
    });
  });
}
