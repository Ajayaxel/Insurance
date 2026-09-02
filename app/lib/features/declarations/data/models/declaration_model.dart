import '../../domain/entities/declaration_entity.dart';

class DeclarationModel extends DeclarationEntity {
  const DeclarationModel({
    required super.id,
    required super.category,
    required super.status,
    required super.answers,
    super.createdAt,
    super.updatedAt,
  });

  factory DeclarationModel.fromJson(Map<String, dynamic> json) {
    return DeclarationModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      status: json['status']?.toString() ?? 'DRAFT',
      answers: (json['answers'] is Map<String, dynamic>)
          ? Map<String, dynamic>.from(json['answers'] as Map)
          : <String, dynamic>{},
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString(),
      updatedAt: json['updatedAt']?.toString() ?? json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'status': status,
      'answers': answers,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }
}

class DeclarationFormSchemaModel extends DeclarationFormSchemaEntity {
  const DeclarationFormSchemaModel({
    required super.category,
    super.title,
    required super.schema,
  });

  factory DeclarationFormSchemaModel.fromJson(Map<String, dynamic> json) {
    return DeclarationFormSchemaModel(
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString(),
      schema: (json['schema'] is Map<String, dynamic>)
          ? Map<String, dynamic>.from(json['schema'] as Map)
          : (json['form'] is Map<String, dynamic>)
              ? Map<String, dynamic>.from(json['form'] as Map)
              : json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      if (title != null) 'title': title,
      'schema': schema,
    };
  }
}
