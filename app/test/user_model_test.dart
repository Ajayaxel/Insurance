import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel parsing tests', () {
    test('should parse /portal/auth/login payload correctly', () {
      final jsonResponse = {
        "accessToken":
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjbXRpODFrdXUwMDAzcmc0ODY5enk2OGVlIiwib3JnIjoiY21zcjFjbzFlMDAxa253MDFmNTFqeHVmZiIsInR5cGUiOiJJTlNVUkFOQ0VfQUdFTlQiLCJyZWFsbSI6InBvcnRhbCIsImlhdCI6MTc4ODI0MDQxMiwiZXhwIjoxNzg4MjY5MjEyfQ.l6JAjnlBkvMqt4izASXTcAk3fyAf4WzUqhCiECFiHp0",
        "user": {
          "id": "cmti81kuu0003rg4869zy68ee",
          "type": "INSURANCE_AGENT",
          "name": "Vinod Kumar",
          "email": "agent@bmninsurance.test",
          "organizationId": "cmsr1co1e001knw01f51jxuff",
          "studentId": null,
          "guardianId": null,
          "facultyId": null
        }
      };

      final user = UserModel.fromJson(jsonResponse);

      expect(user.id, 'cmti81kuu0003rg4869zy68ee');
      expect(user.email, 'agent@bmninsurance.test');
      expect(user.name, 'Vinod Kumar');
      expect(user.ctxType, 'INSURANCE_AGENT');
      expect(user.isAgent, isTrue);
      expect(user.token, jsonResponse['accessToken']);
      expect(user.organizationId, 'cmsr1co1e001knw01f51jxuff');
      expect(user.studentId, isNull);
      expect(user.guardianId, isNull);
      expect(user.facultyId, isNull);
    });

    test('should encode to JSON correctly including accessToken and type', () {
      const user = UserModel(
        id: 'usr_123',
        email: 'test@example.com',
        name: 'Jane Doe',
        ctxType: 'INSURANCE_AGENT',
        token: 'token_abc_123',
        organizationId: 'org_999',
      );

      final jsonMap = user.toJson();

      expect(jsonMap['id'], 'usr_123');
      expect(jsonMap['email'], 'test@example.com');
      expect(jsonMap['name'], 'Jane Doe');
      expect(jsonMap['ctxType'], 'INSURANCE_AGENT');
      expect(jsonMap['type'], 'INSURANCE_AGENT');
      expect(jsonMap['token'], 'token_abc_123');
      expect(jsonMap['accessToken'], 'token_abc_123');
      expect(jsonMap['organizationId'], 'org_999');
    });
  });
}
