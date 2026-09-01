import 'dart:typed_data';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/policy_document_entity.dart';
import '../../domain/entities/policy_entity.dart';
import '../../domain/repositories/policy_repository.dart';
import '../datasources/policy_remote_data_source.dart';

class PolicyRepositoryImpl implements PolicyRepository {
  final PolicyRemoteDataSource remoteDataSource;

  PolicyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PolicyEntity>> getPolicies({required String token}) async {
    try {
      final models = await remoteDataSource.getPolicies(token: token);
      return models;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred while loading policies: ${e.toString()}',
      );
    }
  }

  @override
  Future<Uint8List> getPolicyDocumentBytes({
    required String token,
    required String policyId,
  }) async {
    try {
      final bytes = await remoteDataSource.getPolicyDocumentBytes(
        token: token,
        policyId: policyId,
      );
      return bytes;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred while downloading policy document: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<PolicyDocumentEntity>> getPolicyDocumentsList({
    required String token,
    required String policyId,
  }) async {
    try {
      final documents = await remoteDataSource.getPolicyDocumentsList(
        token: token,
        policyId: policyId,
      );
      return documents;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred while retrieving policy documents list: ${e.toString()}',
      );
    }
  }
}
