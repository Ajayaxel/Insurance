import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/tax_certificate/data/models/tax_certificate_model.dart';

void main() {
  group('TaxCertificateModel parsing tests', () {
    test('should parse tax certificate API response correctly', () {
      final jsonResponse = {
        "broker": {
          "name": "BMN Insurance Brokers",
          "country": "IN",
          "currency": "INR"
        },
        "insured": {
          "name": "Rajesh Menon",
          "email": "rajesh.menon@example.com",
          "phone": "9846012001"
        },
        "financialYear": "2026-27",
        "period": {
          "from": "2026-04-01T00:00:00.000Z",
          "to": "2027-03-31T23:59:59.000Z"
        },
        "lines": [
          {
            "policyNumber": "POL-8849-HEALTH",
            "policyType": "HEALTH",
            "premiumAmountInr": 25000,
            "taxDeductionSection": "80D"
          }
        ],
        "totals": {
          "premiumInr": 25000,
          "healthPremiumInr": 25000,
          "lifePremiumInr": 0
        },
        "generatedAt": "2026-09-01T05:35:27.754Z"
      };

      final model = TaxCertificateModel.fromJson(jsonResponse);

      expect(model.broker.name, 'BMN Insurance Brokers');
      expect(model.broker.country, 'IN');
      expect(model.broker.currency, 'INR');

      expect(model.insured.name, 'Rajesh Menon');
      expect(model.insured.email, 'rajesh.menon@example.com');
      expect(model.insured.phone, '9846012001');

      expect(model.financialYear, '2026-27');
      expect(model.period.from, '2026-04-01T00:00:00.000Z');
      expect(model.period.to, '2027-03-31T23:59:59.000Z');

      expect(model.lines.length, 1);
      expect(model.lines.first.policyNumber, 'POL-8849-HEALTH');
      expect(model.lines.first.premiumAmountInr, 25000);
      expect(model.lines.first.taxDeductionSection, '80D');

      expect(model.totals.premiumInr, 25000);
      expect(model.totals.healthPremiumInr, 25000);
      expect(model.totals.lifePremiumInr, 0);

      expect(model.generatedAt, '2026-09-01T05:35:27.754Z');
    });

    test('should encode TaxCertificateModel to JSON correctly', () {
      final jsonResponse = {
        "broker": {
          "name": "BMN Insurance Brokers",
          "country": "IN",
          "currency": "INR"
        },
        "insured": {
          "name": "Rajesh Menon",
          "email": "rajesh.menon@example.com",
          "phone": "9846012001"
        },
        "financialYear": "2026-27",
        "period": {
          "from": "2026-04-01T00:00:00.000Z",
          "to": "2027-03-31T23:59:59.000Z"
        },
        "lines": [],
        "totals": {
          "premiumInr": 0,
          "healthPremiumInr": 0,
          "lifePremiumInr": 0
        },
        "generatedAt": "2026-09-01T05:35:27.754Z"
      };

      final model = TaxCertificateModel.fromJson(jsonResponse);
      final encodedJson = model.toJson();

      expect(encodedJson['financialYear'], '2026-27');
      expect(encodedJson['broker']['name'], 'BMN Insurance Brokers');
      expect(encodedJson['totals']['premiumInr'], 0);
    });
  });
}
