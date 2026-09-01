import '../entities/declaration_entity.dart';
import '../repositories/declaration_repository.dart';

class GetDeclarationByIdUseCase {
  final DeclarationRepository repository;

  GetDeclarationByIdUseCase(this.repository);

  Future<DeclarationEntity> call({
    required String token,
    required String declarationId,
  }) async {
    return await repository.getDeclarationById(token: token, declarationId: declarationId);
  }
}
