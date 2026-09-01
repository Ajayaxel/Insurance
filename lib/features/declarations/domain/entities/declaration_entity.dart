import 'package:equatable/equatable.dart';

class DeclarationEntity extends Equatable {
  final String id;
  final String category;
  final String status;
  final Map<String, dynamic> answers;
  final String? createdAt;
  final String? updatedAt;

  const DeclarationEntity({
    required this.id,
    required this.category,
    required this.status,
    required this.answers,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        status,
        answers,
        createdAt,
        updatedAt,
      ];
}

class DeclarationFormSchemaEntity extends Equatable {
  final String category;
  final String? title;
  final Map<String, dynamic> schema;

  const DeclarationFormSchemaEntity({
    required this.category,
    this.title,
    required this.schema,
  });

  @override
  List<Object?> get props => [category, title, schema];
}
