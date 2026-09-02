import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../domain/entities/policy_document_entity.dart';
import '../../domain/entities/policy_entity.dart';

abstract class PolicyState extends Equatable {
  const PolicyState();

  @override
  List<Object?> get props => [];
}

class PolicyInitialState extends PolicyState {}

class PolicyLoadingState extends PolicyState {}

class PolicyLoadedState extends PolicyState {
  final List<PolicyEntity> policies;

  const PolicyLoadedState({required this.policies});

  @override
  List<Object?> get props => [policies];
}

class PolicyDocumentDownloadingState extends PolicyState {
  final String policyId;

  const PolicyDocumentDownloadingState(this.policyId);

  @override
  List<Object?> get props => [policyId];
}

class PolicyDocumentDownloadedState extends PolicyState {
  final String policyId;
  final Uint8List documentBytes;

  const PolicyDocumentDownloadedState({
    required this.policyId,
    required this.documentBytes,
  });

  @override
  List<Object?> get props => [policyId, documentBytes];
}

class PolicyDocumentsListLoadingState extends PolicyState {
  final String policyId;

  const PolicyDocumentsListLoadingState(this.policyId);

  @override
  List<Object?> get props => [policyId];
}

class PolicyDocumentsListLoadedState extends PolicyState {
  final String policyId;
  final List<PolicyDocumentEntity> documents;

  const PolicyDocumentsListLoadedState({
    required this.policyId,
    required this.documents,
  });

  @override
  List<Object?> get props => [policyId, documents];
}

class PolicyErrorState extends PolicyState {
  final String message;

  const PolicyErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
