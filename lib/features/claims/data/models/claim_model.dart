import '../../domain/entities/claim_entity.dart';

class ClaimDocumentModel extends ClaimDocumentEntity {
  const ClaimDocumentModel({
    required super.key,
    required super.url,
  });

  factory ClaimDocumentModel.fromJson(Map<String, dynamic> json) {
    return ClaimDocumentModel(
      key: (json['key'] ?? json['id'] ?? json['title'] ?? '').toString(),
      url: (json['url'] ?? json['fileUrl'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'url': url,
    };
  }
}

class ClaimModel extends ClaimEntity {
  const ClaimModel({
    required super.id,
    super.policyId,
    required super.status,
    required super.incidentDate,
    required super.description,
    required super.estimatedAmountInr,
    super.createdAt,
    super.documents,
  });

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    final docsRaw = (json['documents'] as List<dynamic>?) ?? [];
    final docs = docsRaw
        .map((d) => ClaimDocumentModel.fromJson(d as Map<String, dynamic>))
        .toList();

    return ClaimModel(
      id: (json['id'] ?? json['_id'] ?? json['claimId'] ?? '').toString(),
      policyId: json['policyId']?.toString(),
      status: (json['status'] ?? 'SUBMITTED').toString(),
      incidentDate: (json['incidentDate'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      estimatedAmountInr: (json['estimatedAmountInr'] ?? 0) as num,
      createdAt: json['createdAt']?.toString() ?? json['submittedAt']?.toString(),
      documents: docs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (policyId != null) 'policyId': policyId,
      'status': status,
      'incidentDate': incidentDate,
      'description': description,
      'estimatedAmountInr': estimatedAmountInr,
      if (createdAt != null) 'createdAt': createdAt,
      'documents': documents.map((d) => (d as ClaimDocumentModel).toJson()).toList(),
    };
  }
}
