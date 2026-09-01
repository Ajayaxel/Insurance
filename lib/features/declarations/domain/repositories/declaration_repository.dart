import '../entities/declaration_entity.dart';

abstract class DeclarationRepository {
  /// Fetches form schema for specified category (e.g. health, motor)
  Future<DeclarationFormSchemaEntity> getDeclarationForm({
    required String token,
    required String category,
  });

  /// Fetches list of all declarations for customer
  Future<List<DeclarationEntity>> getDeclarations({
    required String token,
  });

  /// Fetches a single declaration by ID
  Future<DeclarationEntity> getDeclarationById({
    required String token,
    required String declarationId,
  });

  /// Saves answers draft idempotently for specified declaration ID
  Future<DeclarationEntity> saveDeclarationDraft({
    required String token,
    required String declarationId,
    required Map<String, dynamic> answers,
  });

  /// Submits declaration for specified declaration ID
  Future<DeclarationEntity> submitDeclaration({
    required String token,
    required String declarationId,
    Map<String, dynamic>? answers,
  });

  /// Creates a new revision after submission
  Future<DeclarationEntity> reviseDeclaration({
    required String token,
    required String declarationId,
  });

  /// Fetches print/PDF document link or contents for signed declaration
  Future<String> printDeclaration({
    required String token,
    required String declarationId,
  });
}
