import 'package:equatable/equatable.dart';
import '../../domain/entities/tax_certificate_entity.dart';

abstract class TaxCertificateState extends Equatable {
  const TaxCertificateState();

  @override
  List<Object?> get props => [];
}

class TaxCertificateInitialState extends TaxCertificateState {}

class TaxCertificateLoadingState extends TaxCertificateState {}

class TaxCertificateLoadedState extends TaxCertificateState {
  final TaxCertificateEntity certificate;
  final String selectedFinancialYear;

  const TaxCertificateLoadedState({
    required this.certificate,
    required this.selectedFinancialYear,
  });

  @override
  List<Object?> get props => [certificate, selectedFinancialYear];
}

class TaxCertificateErrorState extends TaxCertificateState {
  final String message;

  const TaxCertificateErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
