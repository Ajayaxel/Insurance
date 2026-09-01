import '../entities/claim_entity.dart';
import '../repositories/claim_repository.dart';

class AttachClaimDocsUseCase {
  final ClaimRepository repository;

  AttachClaimDocsUseCase(this.repository);

  Future<ClaimEntity> call({
    required String token,
    required String claimId,
    required List<ClaimDocumentEntity> documents,
  }) async {
    return await repository.attachClaimDocs(
      token: token,
      claimId: claimId,
      documents: documents,
    );
  }
}
