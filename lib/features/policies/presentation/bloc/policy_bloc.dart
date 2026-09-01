import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/download_policy_document_usecase.dart';
import '../../domain/usecases/get_policies_usecase.dart';
import '../../domain/usecases/get_policy_documents_list_usecase.dart';
import 'policy_event.dart';
import 'policy_state.dart';

class PolicyBloc extends Bloc<PolicyEvent, PolicyState> {
  final GetPoliciesUseCase getPoliciesUseCase;
  final DownloadPolicyDocumentUseCase? downloadPolicyDocumentUseCase;
  final GetPolicyDocumentsListUseCase? getPolicyDocumentsListUseCase;

  PolicyBloc({
    required this.getPoliciesUseCase,
    this.downloadPolicyDocumentUseCase,
    this.getPolicyDocumentsListUseCase,
  }) : super(PolicyInitialState()) {
    on<FetchPoliciesEvent>(_onFetchPolicies);
    on<DownloadPolicyDocumentEvent>(_onDownloadPolicyDocument);
    on<FetchPolicyDocumentsListEvent>(_onFetchPolicyDocumentsList);
  }

  Future<void> _onFetchPolicies(
    FetchPoliciesEvent event,
    Emitter<PolicyState> emit,
  ) async {
    emit(PolicyLoadingState());
    try {
      final policies = await getPoliciesUseCase(token: event.token);
      emit(PolicyLoadedState(policies: policies));
    } catch (e) {
      emit(PolicyErrorState(
        e.toString().replaceAll('Exception: ', '').replaceAll('ServerException: ', ''),
      ));
    }
  }

  Future<void> _onDownloadPolicyDocument(
    DownloadPolicyDocumentEvent event,
    Emitter<PolicyState> emit,
  ) async {
    if (downloadPolicyDocumentUseCase == null) return;
    emit(PolicyDocumentDownloadingState(event.policyId));
    try {
      final bytes = await downloadPolicyDocumentUseCase!(
        token: event.token,
        policyId: event.policyId,
      );
      emit(PolicyDocumentDownloadedState(
        policyId: event.policyId,
        documentBytes: bytes,
      ));
    } catch (e) {
      emit(PolicyErrorState(
        e.toString().replaceAll('Exception: ', '').replaceAll('ServerException: ', ''),
      ));
    }
  }

  Future<void> _onFetchPolicyDocumentsList(
    FetchPolicyDocumentsListEvent event,
    Emitter<PolicyState> emit,
  ) async {
    if (getPolicyDocumentsListUseCase == null) return;
    emit(PolicyDocumentsListLoadingState(event.policyId));
    try {
      final docs = await getPolicyDocumentsListUseCase!(
        token: event.token,
        policyId: event.policyId,
      );
      emit(PolicyDocumentsListLoadedState(
        policyId: event.policyId,
        documents: docs,
      ));
    } catch (e) {
      emit(PolicyErrorState(
        e.toString().replaceAll('Exception: ', '').replaceAll('ServerException: ', ''),
      ));
    }
  }
}
