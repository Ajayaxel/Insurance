import '../entities/tax_certificate_entity.dart';

abstract class TaxCertificateRepository {
  /// Fetches 80D tax certificate for specified financial year
  Future<TaxCertificateEntity> getTaxCertificate({
    required String token,
    String? financialYear,
  });
}
