import '../entities/declaration_entity.dart';
import '../repositories/declaration_repository.dart';

class SaveDeclarationDraftUseCase {
  final DeclarationRepository repository;

  SaveDeclarationDraftUseCase(this.repository);

  Future<DeclarationEntity> call({
    required String token,
    required String declarationId,
    required Map<String, dynamic> answers,
  }) async {
    return await repository.saveDeclarationDraft(
      token: token,
      declarationId: declarationId,
      answers: answers,
    );
  }
}
