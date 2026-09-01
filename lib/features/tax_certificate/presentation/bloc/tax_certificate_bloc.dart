import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_tax_certificate_usecase.dart';
import 'tax_certificate_event.dart';
import 'tax_certificate_state.dart';

class TaxCertificateBloc
    extends Bloc<TaxCertificateEvent, TaxCertificateState> {
  final GetTaxCertificateUseCase getTaxCertificateUseCase;

  TaxCertificateBloc({required this.getTaxCertificateUseCase})
      : super(TaxCertificateInitialState()) {
    on<FetchTaxCertificateEvent>(_onFetchTaxCertificate);
  }

  Future<void> _onFetchTaxCertificate(
    FetchTaxCertificateEvent event,
    Emitter<TaxCertificateState> emit,
  ) async {
    emit(TaxCertificateLoadingState());
    try {
      final certificate = await getTaxCertificateUseCase(
        token: event.token,
        financialYear: event.financialYear,
      );
      final fy = (event.financialYear != null && event.financialYear!.isNotEmpty)
          ? event.financialYear!
          : (certificate.financialYear.isNotEmpty
              ? certificate.financialYear
              : '2026-27');

      emit(TaxCertificateLoadedState(
        certificate: certificate,
        selectedFinancialYear: fy,
      ));
    } catch (e) {
      emit(TaxCertificateErrorState(
        e.toString().replaceAll('Exception: ', '').replaceAll('ServerException: ', ''),
      ));
    }
  }
}
