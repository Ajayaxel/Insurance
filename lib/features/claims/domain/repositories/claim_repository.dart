import '../entities/claim_entity.dart';

abstract class ClaimRepository {
  /// Fetches claims list
  Future<List<ClaimEntity>> getClaims({required String token});

  /// Raises a new claim for specified policyId
  Future<ClaimEntity> raiseClaim({
    required String token,
    required String policyId,
    required String incidentDate,
    required String description,
    required num estimatedAmountInr,
  });

  /// Attaches documents to specified claimId
  Future<ClaimEntity> attachClaimDocs({
    required String token,
    required String claimId,
    required List<ClaimDocumentEntity> documents,
  });
}
