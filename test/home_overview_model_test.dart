import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/home/data/models/home_overview_model.dart';

void main() {
  group('HomeOverviewModel parsing tests', () {
    test('should parse /portal/me/insurance/overview response payload correctly', () {
      final jsonMap = {
        "client": {
          "name": "Rajesh Menon",
          "email": "rajesh.menon@example.com",
          "phone": "9846012001",
          "type": "INDIVIDUAL"
        },
        "currency": "INR",
        "kpis": {
          "activePolicies": 2,
          "totalSumInsuredInr": 1500000,
          "annualPremiumInr": 35000,
          "openClaims": 0
        },
        "renewalAlerts": [],
        "policies": [],
        "claims": [],
        "support": []
      };

      final model = HomeOverviewModel.fromJson(jsonMap);

      expect(model.client.name, 'Rajesh Menon');
      expect(model.client.email, 'rajesh.menon@example.com');
      expect(model.client.phone, '9846012001');
      expect(model.client.type, 'INDIVIDUAL');

      expect(model.currency, 'INR');

      expect(model.kpis.activePolicies, 2);
      expect(model.kpis.totalSumInsuredInr, 1500000);
      expect(model.kpis.annualPremiumInr, 35000);
      expect(model.kpis.openClaims, 0);

      expect(model.renewalAlerts, isEmpty);
      expect(model.policies, isEmpty);
      expect(model.claims, isEmpty);
      expect(model.support, isEmpty);
    });

    test('should encode HomeOverviewModel to JSON correctly', () {
      const model = HomeOverviewModel(
        client: ClientModel(
          name: 'Rajesh Menon',
          email: 'rajesh.menon@example.com',
          phone: '9846012001',
          type: 'INDIVIDUAL',
        ),
        currency: 'INR',
        kpis: KpisModel(
          activePolicies: 0,
          totalSumInsuredInr: 0,
          annualPremiumInr: 0,
          openClaims: 0,
        ),
        renewalAlerts: [],
        policies: [],
        claims: [],
        support: [],
      );

      final json = model.toJson();

      expect(json['client']['name'], 'Rajesh Menon');
      expect(json['currency'], 'INR');
      expect(json['kpis']['activePolicies'], 0);
    });
  });
}
