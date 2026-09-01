import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/claims/domain/entities/claim_entity.dart';
import 'package:app/features/claims/domain/repositories/claim_repository.dart';
import 'package:app/features/claims/domain/usecases/attach_claim_docs_usecase.dart';
import 'package:app/features/claims/domain/usecases/get_claims_usecase.dart';
import 'package:app/features/claims/domain/usecases/raise_claim_usecase.dart';
import 'package:app/features/claims/presentation/bloc/claim_bloc.dart';
import 'package:app/features/claims/presentation/bloc/claim_event.dart';
import 'package:app/features/claims/presentation/bloc/claim_state.dart';

class MockClaimRepository implements ClaimRepository {
  final bool shouldFail;

  MockClaimRepository({this.shouldFail = false});

  @override
  Future<List<ClaimEntity>> getClaims({required String token}) async {
    if (shouldFail) throw Exception('Failed to fetch claims');
    return const [
      ClaimEntity(
        id: 'clm_1',
        status: 'SUBMITTED',
        incidentDate: '2026-08-01',
        description: 'Bumper damage',
        estimatedAmountInr: 45000,
      ),
    ];
  }

  @override
  Future<ClaimEntity> raiseClaim({
    required String token,
    required String policyId,
    required String incidentDate,
    required String description,
    required num estimatedAmountInr,
  }) async {
    if (shouldFail) throw Exception('Failed to raise claim');
    return ClaimEntity(
      id: 'clm_new',
      policyId: policyId,
      status: 'SUBMITTED',
      incidentDate: incidentDate,
      description: description,
      estimatedAmountInr: estimatedAmountInr,
    );
  }

  @override
  Future<ClaimEntity> attachClaimDocs({
    required String token,
    required String claimId,
    required List<ClaimDocumentEntity> documents,
  }) async {
    if (shouldFail) throw Exception('Failed to attach docs');
    return ClaimEntity(
      id: claimId,
      status: 'SUBMITTED',
      incidentDate: '2026-08-01',
      description: 'Bumper damage',
      estimatedAmountInr: 45000,
      documents: documents,
    );
  }
}

void main() {
  group('ClaimBloc tests', () {
    late MockClaimRepository repository;
    late GetClaimsUseCase getClaimsUseCase;
    late RaiseClaimUseCase raiseClaimUseCase;
    late AttachClaimDocsUseCase attachClaimDocsUseCase;

    setUp(() {
      repository = MockClaimRepository();
      getClaimsUseCase = GetClaimsUseCase(repository);
      raiseClaimUseCase = RaiseClaimUseCase(repository);
      attachClaimDocsUseCase = AttachClaimDocsUseCase(repository);
    });

    test('initial state should be ClaimInitialState', () {
      final bloc = ClaimBloc(
        getClaimsUseCase: getClaimsUseCase,
        raiseClaimUseCase: raiseClaimUseCase,
        attachClaimDocsUseCase: attachClaimDocsUseCase,
      );

      expect(bloc.state, isA<ClaimInitialState>());
    });

    test('should emit [ClaimLoadingState, ClaimsLoadedState] on FetchClaimsEvent', () async {
      final bloc = ClaimBloc(
        getClaimsUseCase: getClaimsUseCase,
        raiseClaimUseCase: raiseClaimUseCase,
        attachClaimDocsUseCase: attachClaimDocsUseCase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ClaimLoadingState>(),
          isA<ClaimsLoadedState>().having((s) => s.claims.length, 'length', 1),
        ]),
      );

      bloc.add(const FetchClaimsEvent(token: 'mock_token'));
    });

    test('should emit [ClaimLoadingState, ClaimSubmittedSuccessState] on RaiseClaimEvent', () async {
      final bloc = ClaimBloc(
        getClaimsUseCase: getClaimsUseCase,
        raiseClaimUseCase: raiseClaimUseCase,
        attachClaimDocsUseCase: attachClaimDocsUseCase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ClaimLoadingState>(),
          isA<ClaimSubmittedSuccessState>().having((s) => s.claim.id, 'id', 'clm_new'),
        ]),
      );

      bloc.add(const RaiseClaimEvent(
        token: 'mock_token',
        policyId: 'pol_1',
        incidentDate: '2026-08-01',
        description: 'Rear ended',
        estimatedAmountInr: 45000,
      ));
    });
  });
}
