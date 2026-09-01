import '../entities/policy_document_entity.dart';
import '../repositories/policy_repository.dart';

class GetPolicyDocumentsListUseCase {
  final PolicyRepository repository;

  GetPolicyDocumentsListUseCase(this.repository);

  Future<List<PolicyDocumentEntity>> call({
    required String token,
    required String policyId,
  }) async {
    return await repository.getPolicyDocumentsList(
      token: token,
      policyId: policyId,
    );
  }
}
