import '../entities/declaration_entity.dart';
import '../repositories/declaration_repository.dart';

class GetDeclarationFormUseCase {
  final DeclarationRepository repository;

  GetDeclarationFormUseCase(this.repository);

  Future<DeclarationFormSchemaEntity> call({
    required String token,
    required String category,
  }) async {
    return await repository.getDeclarationForm(token: token, category: category);
  }
}
