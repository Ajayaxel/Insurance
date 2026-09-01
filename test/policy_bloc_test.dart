import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/policies/domain/entities/policy_document_entity.dart';
import 'package:app/features/policies/domain/entities/policy_entity.dart';
import 'package:app/features/policies/domain/repositories/policy_repository.dart';
import 'package:app/features/policies/domain/usecases/download_policy_document_usecase.dart';
import 'package:app/features/policies/domain/usecases/get_policies_usecase.dart';
import 'package:app/features/policies/domain/usecases/get_policy_documents_list_usecase.dart';
import 'package:app/features/policies/presentation/bloc/policy_bloc.dart';
import 'package:app/features/policies/presentation/bloc/policy_event.dart';
import 'package:app/features/policies/presentation/bloc/policy_state.dart';

class MockPolicyRepository implements PolicyRepository {
  final bool returnEmpty;
  final bool shouldFail;

  MockPolicyRepository({this.returnEmpty = false, this.shouldFail = false});

  @override
  Future<List<PolicyEntity>> getPolicies({required String token}) async {
    if (shouldFail) {
      throw Exception('Failed to connect to policies endpoint');
    }
    if (returnEmpty) {
      return [];
    }
    return const [
      PolicyEntity(
        id: 'pol_1',
        policyNumber: 'POL-2026-001',
        type: 'HEALTH',
        status: 'ACTIVE',
        planName: 'Gold Health Plan',
        insuredAmountInr: 1000000,
        premiumAmountInr: 22000,
      ),
    ];
  }

  @override
  Future<Uint8List> getPolicyDocumentBytes({
    required String token,
    required String policyId,
  }) async {
    if (shouldFail) {
      throw Exception('Failed to download policy PDF document');
    }
    return Uint8List.fromList([37, 80, 68, 70]); // %PDF bytes
  }

  @override
  Future<List<PolicyDocumentEntity>> getPolicyDocumentsList({
    required String token,
    required String policyId,
  }) async {
    if (shouldFail) {
      throw Exception('Failed to fetch policy documents list');
    }
    return const [
      PolicyDocumentEntity(
        id: 'doc_1',
        name: 'Policy Wording.pdf',
        url: 'https://example.com/wording.pdf',
        type: 'PDF',
      ),
    ];
  }
}

void main() {
  group('PolicyBloc tests', () {
    test('initial state should be PolicyInitialState', () {
      final repository = MockPolicyRepository();
      final useCase = GetPoliciesUseCase(repository);
      final bloc = PolicyBloc(getPoliciesUseCase: useCase);

      expect(bloc.state, isA<PolicyInitialState>());
    });

    test('should emit [PolicyLoadingState, PolicyLoadedState] with empty list when API returns []', () async {
      final repository = MockPolicyRepository(returnEmpty: true);
      final useCase = GetPoliciesUseCase(repository);
      final bloc = PolicyBloc(getPoliciesUseCase: useCase);

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PolicyLoadingState>(),
          isA<PolicyLoadedState>().having((s) => s.policies.isEmpty, 'empty policies', isTrue),
        ]),
      );

      bloc.add(const FetchPoliciesEvent(token: 'mock_token'));
    });

    test('should emit [PolicyLoadingState, PolicyLoadedState] when API returns populated policies', () async {
      final repository = MockPolicyRepository(returnEmpty: false);
      final useCase = GetPoliciesUseCase(repository);
      final bloc = PolicyBloc(getPoliciesUseCase: useCase);

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PolicyLoadingState>(),
          isA<PolicyLoadedState>().having((s) => s.policies.length, 'policies length', 1),
        ]),
      );

      bloc.add(const FetchPoliciesEvent(token: 'mock_token'));
    });

    test('should emit [PolicyDocumentDownloadingState, PolicyDocumentDownloadedState] when downloading document PDF', () async {
      final repository = MockPolicyRepository();
      final getPoliciesUseCase = GetPoliciesUseCase(repository);
      final downloadDocUseCase = DownloadPolicyDocumentUseCase(repository);
      final bloc = PolicyBloc(
        getPoliciesUseCase: getPoliciesUseCase,
        downloadPolicyDocumentUseCase: downloadDocUseCase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PolicyDocumentDownloadingState>().having((s) => s.policyId, 'policyId', 'pol_1'),
          isA<PolicyDocumentDownloadedState>().having((s) => s.documentBytes.length, 'bytes length', 4),
        ]),
      );

      bloc.add(const DownloadPolicyDocumentEvent(token: 'mock_token', policyId: 'pol_1'));
    });

    test('should emit [PolicyDocumentsListLoadingState, PolicyDocumentsListLoadedState] when fetching policy documents list', () async {
      final repository = MockPolicyRepository();
      final getPoliciesUseCase = GetPoliciesUseCase(repository);
      final getDocsListUseCase = GetPolicyDocumentsListUseCase(repository);
      final bloc = PolicyBloc(
        getPoliciesUseCase: getPoliciesUseCase,
        getPolicyDocumentsListUseCase: getDocsListUseCase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PolicyDocumentsListLoadingState>().having((s) => s.policyId, 'policyId', 'pol_1'),
          isA<PolicyDocumentsListLoadedState>().having((s) => s.documents.length, 'documents length', 1),
        ]),
      );

      bloc.add(const FetchPolicyDocumentsListEvent(token: 'mock_token', policyId: 'pol_1'));
    });

    test('should emit [PolicyLoadingState, PolicyErrorState] when API fails', () async {
      final repository = MockPolicyRepository(shouldFail: true);
      final useCase = GetPoliciesUseCase(repository);
      final bloc = PolicyBloc(getPoliciesUseCase: useCase);

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<PolicyLoadingState>(),
          isA<PolicyErrorState>(),
        ]),
      );

      bloc.add(const FetchPoliciesEvent(token: 'mock_token'));
    });
  });
}
