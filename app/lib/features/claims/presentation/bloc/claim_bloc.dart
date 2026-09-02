import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/attach_claim_docs_usecase.dart';
import '../../domain/usecases/get_claims_usecase.dart';
import '../../domain/usecases/raise_claim_usecase.dart';
import 'claim_event.dart';
import 'claim_state.dart';

class ClaimBloc extends Bloc<ClaimEvent, ClaimState> {
  final GetClaimsUseCase getClaimsUseCase;
  final RaiseClaimUseCase raiseClaimUseCase;
  final AttachClaimDocsUseCase attachClaimDocsUseCase;

  ClaimBloc({
    required this.getClaimsUseCase,
    required this.raiseClaimUseCase,
    required this.attachClaimDocsUseCase,
  }) : super(ClaimInitialState()) {
    on<FetchClaimsEvent>(_onFetchClaims);
    on<RaiseClaimEvent>(_onRaiseClaim);
    on<AttachClaimDocsEvent>(_onAttachClaimDocs);
  }

  Future<void> _onFetchClaims(
    FetchClaimsEvent event,
    Emitter<ClaimState> emit,
  ) async {
    emit(ClaimLoadingState());
    try {
      final claims = await getClaimsUseCase(token: event.token);
      emit(ClaimsLoadedState(claims: claims));
    } catch (e) {
      emit(ClaimErrorState(
        e.toString().replaceAll('Exception: ', '').replaceAll('ServerException: ', ''),
      ));
    }
  }

  Future<void> _onRaiseClaim(
    RaiseClaimEvent event,
    Emitter<ClaimState> emit,
  ) async {
    emit(ClaimLoadingState());
    try {
      final claim = await raiseClaimUseCase(
        token: event.token,
        policyId: event.policyId,
        incidentDate: event.incidentDate,
        description: event.description,
        estimatedAmountInr: event.estimatedAmountInr,
      );
      emit(ClaimSubmittedSuccessState(
        claim: claim,
        message: 'Claim raised successfully!',
      ));
    } catch (e) {
      emit(ClaimErrorState(
        e.toString().replaceAll('Exception: ', '').replaceAll('ServerException: ', ''),
      ));
    }
  }

  Future<void> _onAttachClaimDocs(
    AttachClaimDocsEvent event,
    Emitter<ClaimState> emit,
  ) async {
    emit(ClaimLoadingState());
    try {
      final updatedClaim = await attachClaimDocsUseCase(
        token: event.token,
        claimId: event.claimId,
        documents: event.documents,
      );
      emit(ClaimSubmittedSuccessState(
        claim: updatedClaim,
        message: 'Documents attached successfully!',
      ));
    } catch (e) {
      emit(ClaimErrorState(
        e.toString().replaceAll('Exception: ', '').replaceAll('ServerException: ', ''),
      ));
    }
  }
}
