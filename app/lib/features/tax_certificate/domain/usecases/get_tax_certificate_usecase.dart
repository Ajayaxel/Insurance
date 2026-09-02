import '../entities/tax_certificate_entity.dart';
import '../repositories/tax_certificate_repository.dart';

class GetTaxCertificateUseCase {
  final TaxCertificateRepository repository;

  GetTaxCertificateUseCase(this.repository);

  Future<TaxCertificateEntity> call({
    required String token,
    String? financialYear,
  }) async {
    return await repository.getTaxCertificate(
      token: token,
      financialYear: financialYear,
    );
  }
}
