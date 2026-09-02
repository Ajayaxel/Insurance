import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/tax_certificate_entity.dart';
import '../../domain/repositories/tax_certificate_repository.dart';
import '../datasources/tax_certificate_remote_data_source.dart';

class TaxCertificateRepositoryImpl implements TaxCertificateRepository {
  final TaxCertificateRemoteDataSource remoteDataSource;

  TaxCertificateRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TaxCertificateEntity> getTaxCertificate({
    required String token,
    String? financialYear,
  }) async {
    try {
      final model = await remoteDataSource.getTaxCertificate(
        token: token,
        financialYear: financialYear,
      );
      return model;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException(
        'An unexpected error occurred while loading tax certificate: ${e.toString()}',
      );
    }
  }
}
