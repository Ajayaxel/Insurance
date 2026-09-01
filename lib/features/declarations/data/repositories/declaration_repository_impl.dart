import '../../domain/entities/declaration_entity.dart';
import '../../domain/repositories/declaration_repository.dart';
import '../datasources/declaration_remote_data_source.dart';

class DeclarationRepositoryImpl implements DeclarationRepository {
  final DeclarationRemoteDataSource remoteDataSource;

  DeclarationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DeclarationFormSchemaEntity> getDeclarationForm({
    required String token,
    required String category,
  }) async {
    return await remoteDataSource.getDeclarationForm(token: token, category: category);
  }

  @override
  Future<List<DeclarationEntity>> getDeclarations({
    required String token,
  }) async {
    return await remoteDataSource.getDeclarations(token: token);
  }

  @override
  Future<DeclarationEntity> getDeclarationById({
    required String token,
    required String declarationId,
  }) async {
    return await remoteDataSource.getDeclarationById(token: token, declarationId: declarationId);
  }

  @override
  Future<DeclarationEntity> saveDeclarationDraft({
    required String token,
    required String declarationId,
    required Map<String, dynamic> answers,
  }) async {
    return await remoteDataSource.saveDeclarationDraft(
      token: token,
      declarationId: declarationId,
      answers: answers,
    );
  }

  @override
  Future<DeclarationEntity> submitDeclaration({
    required String token,
    required String declarationId,
    Map<String, dynamic>? answers,
  }) async {
    return await remoteDataSource.submitDeclaration(
      token: token,
      declarationId: declarationId,
      answers: answers,
    );
  }

  @override
  Future<DeclarationEntity> reviseDeclaration({
    required String token,
    required String declarationId,
  }) async {
    return await remoteDataSource.reviseDeclaration(
      token: token,
      declarationId: declarationId,
    );
  }

  @override
  Future<String> printDeclaration({
    required String token,
    required String declarationId,
  }) async {
    return await remoteDataSource.printDeclaration(
      token: token,
      declarationId: declarationId,
    );
  }
}
