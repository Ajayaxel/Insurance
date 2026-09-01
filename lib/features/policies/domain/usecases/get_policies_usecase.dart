import '../entities/policy_entity.dart';
import '../repositories/policy_repository.dart';

class GetPoliciesUseCase {
  final PolicyRepository repository;

  GetPoliciesUseCase(this.repository);

  Future<List<PolicyEntity>> call({required String token}) async {
    return await repository.getPolicies(token: token);
  }
}
