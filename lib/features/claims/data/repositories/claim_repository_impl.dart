import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/claim_entity.dart';
import '../../domain/repositories/claim_repository.dart';
import '../datasources/claim_remote_data_source.dart';
import '../models/claim_model.dart';

class ClaimRepositoryImpl implements ClaimRepository {
  final ClaimRemoteDataSource remoteDataSource;

  ClaimRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ClaimEntity>> getClaims({required String token}) async {
    try {
      final models = await remoteDataSource.getClaims(token: token);
      return models;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred while fetching claims: ${e.toString()}',
      );
    }
  }

  @override
  Future<ClaimEntity> raiseClaim({
    required String token,
    required String policyId,
    required String incidentDate,
    required String description,
    required num estimatedAmountInr,
  }) async {
    try {
      final model = await remoteDataSource.raiseClaim(
        token: token,
        policyId: policyId,
        incidentDate: incidentDate,
        description: description,
        estimatedAmountInr: estimatedAmountInr,
      );
      return model;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred while raising claim: ${e.toString()}',
      );
    }
  }

  @override
  Future<ClaimEntity> attachClaimDocs({
    required String token,
    required String claimId,
    required List<ClaimDocumentEntity> documents,
  }) async {
    try {
      final docModels = documents
          .map((d) => ClaimDocumentModel(key: d.key, url: d.url))
          .toList();
      final model = await remoteDataSource.attachClaimDocs(
        token: token,
        claimId: claimId,
        documents: docModels,
      );
      return model;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred while attaching claim documents: ${e.toString()}',
      );
    }
  }
}
