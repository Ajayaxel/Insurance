import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/profile/data/models/profile_model.dart';

void main() {
  group('ProfileModel parsing & serialization tests', () {
    test('should parse ProfileModel from JSON correctly', () {
      final jsonMap = {
        "name": "Rajesh Menon",
        "email": "rajesh.menon@example.com",
        "phone": "9846012001",
        "type": "INDIVIDUAL",
        "profile": {}
      };

      final model = ProfileModel.fromJson(jsonMap);

      expect(model.name, 'Rajesh Menon');
      expect(model.email, 'rajesh.menon@example.com');
      expect(model.phone, '9846012001');
      expect(model.type, 'INDIVIDUAL');
      expect(model.profileDetails, isEmpty);
    });

    test('should serialize ProfileModel to JSON correctly', () {
      const model = ProfileModel(
        name: 'Rajesh Menon',
        email: 'rajesh.menon@example.com',
        phone: '9846012001',
        type: 'INDIVIDUAL',
        profileDetails: {},
      );

      final json = model.toJson();

      expect(json['name'], 'Rajesh Menon');
      expect(json['email'], 'rajesh.menon@example.com');
      expect(json['phone'], '9846012001');
      expect(json['type'], 'INDIVIDUAL');
    });
  });
}
