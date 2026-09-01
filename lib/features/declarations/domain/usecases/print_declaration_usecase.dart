import '../repositories/declaration_repository.dart';

class PrintDeclarationUseCase {
  final DeclarationRepository repository;

  PrintDeclarationUseCase(this.repository);

  Future<String> call({
    required String token,
    required String declarationId,
  }) async {
    return await repository.printDeclaration(
      token: token,
      declarationId: declarationId,
    );
  }
}
