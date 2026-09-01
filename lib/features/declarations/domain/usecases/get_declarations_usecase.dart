import '../entities/declaration_entity.dart';
import '../repositories/declaration_repository.dart';

class GetDeclarationsUseCase {
  final DeclarationRepository repository;

  GetDeclarationsUseCase(this.repository);

  Future<List<DeclarationEntity>> call({required String token}) async {
    return await repository.getDeclarations(token: token);
  }
}
