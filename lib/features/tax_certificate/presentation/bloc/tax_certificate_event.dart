import 'package:equatable/equatable.dart';

abstract class TaxCertificateEvent extends Equatable {
  const TaxCertificateEvent();

  @override
  List<Object?> get props => [];
}

class FetchTaxCertificateEvent extends TaxCertificateEvent {
  final String token;
  final String? financialYear;

  const FetchTaxCertificateEvent({
    required this.token,
    this.financialYear,
  });

  @override
  List<Object?> get props => [token, financialYear];
}
