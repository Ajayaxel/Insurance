import '../entities/declaration_entity.dart';
import '../repositories/declaration_repository.dart';

class ReviseDeclarationUseCase {
  final DeclarationRepository repository;

  ReviseDeclarationUseCase(this.repository);

  Future<DeclarationEntity> call({
    required String token,
    required String declarationId,
  }) async {
    return await repository.reviseDeclaration(
      token: token,
      declarationId: declarationId,
    );
  }
}
