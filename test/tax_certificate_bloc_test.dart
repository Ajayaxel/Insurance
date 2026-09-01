import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/tax_certificate/domain/entities/tax_certificate_entity.dart';
import 'package:app/features/tax_certificate/domain/repositories/tax_certificate_repository.dart';
import 'package:app/features/tax_certificate/domain/usecases/get_tax_certificate_usecase.dart';
import 'package:app/features/tax_certificate/presentation/bloc/tax_certificate_bloc.dart';
import 'package:app/features/tax_certificate/presentation/bloc/tax_certificate_event.dart';
import 'package:app/features/tax_certificate/presentation/bloc/tax_certificate_state.dart';

class MockTaxCertificateRepository implements TaxCertificateRepository {
  final bool shouldFail;

  MockTaxCertificateRepository({this.shouldFail = false});

  @override
  Future<TaxCertificateEntity> getTaxCertificate({
    required String token,
    String? financialYear,
  }) async {
    if (shouldFail) {
      throw Exception('Server failure loading certificate');
    }

    return TaxCertificateEntity(
      broker: const BrokerEntity(name: 'BMN Insurance', country: 'IN', currency: 'INR'),
      insured: const InsuredEntity(name: 'Rajesh Menon', email: 'rajesh@example.com', phone: '9846012001'),
      financialYear: financialYear ?? '2026-27',
      period: const PeriodEntity(from: '2026-04-01', to: '2027-03-31'),
      lines: const [],
      totals: const TotalsEntity(premiumInr: 0, healthPremiumInr: 0, lifePremiumInr: 0),
      generatedAt: '2026-09-01T05:35:27.754Z',
    );
  }
}

void main() {
  group('TaxCertificateBloc tests', () {
    test('initial state should be TaxCertificateInitialState', () {
      final repository = MockTaxCertificateRepository();
      final useCase = GetTaxCertificateUseCase(repository);
      final bloc = TaxCertificateBloc(getTaxCertificateUseCase: useCase);

      expect(bloc.state, isA<TaxCertificateInitialState>());
    });

    test('should emit [TaxCertificateLoadingState, TaxCertificateLoadedState] when fetch succeeds', () async {
      final repository = MockTaxCertificateRepository();
      final useCase = GetTaxCertificateUseCase(repository);
      final bloc = TaxCertificateBloc(getTaxCertificateUseCase: useCase);

      final expectedStates = [
        isA<TaxCertificateLoadingState>(),
        isA<TaxCertificateLoadedState>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const FetchTaxCertificateEvent(token: 'mock_token', financialYear: '2026-27'));
    });

    test('should emit [TaxCertificateLoadingState, TaxCertificateErrorState] when fetch fails', () async {
      final repository = MockTaxCertificateRepository(shouldFail: true);
      final useCase = GetTaxCertificateUseCase(repository);
      final bloc = TaxCertificateBloc(getTaxCertificateUseCase: useCase);

      final expectedStates = [
        isA<TaxCertificateLoadingState>(),
        isA<TaxCertificateErrorState>(),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const FetchTaxCertificateEvent(token: 'mock_token', financialYear: '2026-27'));
    });
  });
}
