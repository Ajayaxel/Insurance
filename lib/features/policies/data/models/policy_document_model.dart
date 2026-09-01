import '../../domain/entities/policy_document_entity.dart';

class PolicyDocumentModel extends PolicyDocumentEntity {
  const PolicyDocumentModel({
    required super.id,
    required super.name,
    required super.url,
    super.type,
    super.uploadedAt,
  });

  factory PolicyDocumentModel.fromJson(Map<String, dynamic> json) {
    return PolicyDocumentModel(
      id: (json['id'] ?? json['_id'] ?? json['key'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? json['key'] ?? json['filename'] ?? 'Policy Attachment').toString(),
      url: (json['url'] ?? json['fileUrl'] ?? json['downloadUrl'] ?? '').toString(),
      type: json['type']?.toString() ?? json['mimeType']?.toString() ?? json['key']?.toString(),
      uploadedAt: json['uploadedAt']?.toString() ?? json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'type': type,
      'uploadedAt': uploadedAt,
    };
  }
}
