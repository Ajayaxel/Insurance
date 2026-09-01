import 'package:equatable/equatable.dart';
import '../../domain/entities/claim_entity.dart';

abstract class ClaimEvent extends Equatable {
  const ClaimEvent();

  @override
  List<Object?> get props => [];
}

class FetchClaimsEvent extends ClaimEvent {
  final String token;

  const FetchClaimsEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

class RaiseClaimEvent extends ClaimEvent {
  final String token;
  final String policyId;
  final String incidentDate;
  final String description;
  final num estimatedAmountInr;

  const RaiseClaimEvent({
    required this.token,
    required this.policyId,
    required this.incidentDate,
    required this.description,
    required this.estimatedAmountInr,
  });

  @override
  List<Object?> get props => [
        token,
        policyId,
        incidentDate,
        description,
        estimatedAmountInr,
      ];
}

class AttachClaimDocsEvent extends ClaimEvent {
  final String token;
  final String claimId;
  final List<ClaimDocumentEntity> documents;

  const AttachClaimDocsEvent({
    required this.token,
    required this.claimId,
    required this.documents,
  });

  @override
  List<Object?> get props => [token, claimId, documents];
}
