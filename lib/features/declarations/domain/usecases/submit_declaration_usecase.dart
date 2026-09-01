import '../entities/declaration_entity.dart';
import '../repositories/declaration_repository.dart';

class SubmitDeclarationUseCase {
  final DeclarationRepository repository;

  SubmitDeclarationUseCase(this.repository);

  Future<DeclarationEntity> call({
    required String token,
    required String declarationId,
    Map<String, dynamic>? answers,
  }) async {
    return await repository.submitDeclaration(
      token: token,
      declarationId: declarationId,
      answers: answers,
    );
  }
}
