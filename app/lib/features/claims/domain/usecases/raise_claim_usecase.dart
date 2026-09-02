import '../entities/claim_entity.dart';
import '../repositories/claim_repository.dart';

class RaiseClaimUseCase {
  final ClaimRepository repository;

  RaiseClaimUseCase(this.repository);

  Future<ClaimEntity> call({
    required String token,
    required String policyId,
    required String incidentDate,
    required String description,
    required num estimatedAmountInr,
  }) async {
    return await repository.raiseClaim(
      token: token,
      policyId: policyId,
      incidentDate: incidentDate,
      description: description,
      estimatedAmountInr: estimatedAmountInr,
    );
  }
}
