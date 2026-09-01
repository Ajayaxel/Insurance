import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/declarations/data/models/declaration_model.dart';

void main() {
  group('DeclarationModel parsing & serialization tests', () {
    test('should parse DeclarationModel from JSON correctly', () {
      final jsonMap = {
        'id': 'decl_001',
        'category': 'health',
        'status': 'DRAFT',
        'answers': {
          'tobacco': false,
          'existingConditions': ['asthma'],
        },
        'createdAt': '2026-09-01T10:00:00Z',
        'updatedAt': '2026-09-01T10:05:00Z',
      };

      final model = DeclarationModel.fromJson(jsonMap);

      expect(model.id, 'decl_001');
      expect(model.category, 'health');
      expect(model.status, 'DRAFT');
      expect(model.answers['tobacco'], false);
      expect(model.answers['existingConditions'], ['asthma']);
      expect(model.createdAt, '2026-09-01T10:00:00Z');
      expect(model.updatedAt, '2026-09-01T10:05:00Z');
    });

    test('should serialize DeclarationModel to JSON correctly', () {
      const model = DeclarationModel(
        id: 'decl_002',
        category: 'motor',
        status: 'SUBMITTED',
        answers: {'previousClaims': false},
      );

      final json = model.toJson();

      expect(json['id'], 'decl_002');
      expect(json['category'], 'motor');
      expect(json['status'], 'SUBMITTED');
      expect(json['answers'], {'previousClaims': false});
    });

    test('should parse DeclarationFormSchemaModel from JSON correctly', () {
      final schemaJson = {
        'category': 'health',
        'title': 'Health Declaration Questionnaire',
        'schema': {
          'fields': [
            {'name': 'tobacco', 'type': 'boolean', 'label': 'Do you use tobacco?'},
          ]
        }
      };

      final schemaModel = DeclarationFormSchemaModel.fromJson(schemaJson);

      expect(schemaModel.category, 'health');
      expect(schemaModel.title, 'Health Declaration Questionnaire');
      expect(schemaModel.schema['fields'], isA<List>());
    });
  });
}
