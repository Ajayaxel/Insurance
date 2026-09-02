import '../entities/claim_entity.dart';
import '../repositories/claim_repository.dart';

class GetClaimsUseCase {
  final ClaimRepository repository;

  GetClaimsUseCase(this.repository);

  Future<List<ClaimEntity>> call({required String token}) async {
    return await repository.getClaims(token: token);
  }
}
