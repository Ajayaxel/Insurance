import 'package:equatable/equatable.dart';

abstract class PolicyEvent extends Equatable {
  const PolicyEvent();

  @override
  List<Object?> get props => [];
}

class FetchPoliciesEvent extends PolicyEvent {
  final String token;

  const FetchPoliciesEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

class DownloadPolicyDocumentEvent extends PolicyEvent {
  final String token;
  final String policyId;

  const DownloadPolicyDocumentEvent({
    required this.token,
    required this.policyId,
  });

  @override
  List<Object?> get props => [token, policyId];
}

class FetchPolicyDocumentsListEvent extends PolicyEvent {
  final String token;
  final String policyId;

  const FetchPolicyDocumentsListEvent({
    required this.token,
    required this.policyId,
  });

  @override
  List<Object?> get props => [token, policyId];
}
