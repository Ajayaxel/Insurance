import 'package:equatable/equatable.dart';

class ClaimDocumentEntity extends Equatable {
  final String key;
  final String url;

  const ClaimDocumentEntity({
    required this.key,
    required this.url,
  });

  @override
  List<Object?> get props => [key, url];
}

class ClaimEntity extends Equatable {
  final String id;
  final String? policyId;
  final String status;
  final String incidentDate;
  final String description;
  final num estimatedAmountInr;
  final String? createdAt;
  final List<ClaimDocumentEntity> documents;

  const ClaimEntity({
    required this.id,
    this.policyId,
    required this.status,
    required this.incidentDate,
    required this.description,
    required this.estimatedAmountInr,
    this.createdAt,
    this.documents = const [],
  });

  @override
  List<Object?> get props => [
        id,
        policyId,
        status,
        incidentDate,
        description,
        estimatedAmountInr,
        createdAt,
        documents,
      ];
}
