import 'package:equatable/equatable.dart';

abstract class DeclarationEvent extends Equatable {
  const DeclarationEvent();

  @override
  List<Object?> get props => [];
}

class FetchDeclarationFormEvent extends DeclarationEvent {
  final String token;
  final String category;

  const FetchDeclarationFormEvent({
    required this.token,
    required this.category,
  });

  @override
  List<Object?> get props => [token, category];
}

class FetchDeclarationsEvent extends DeclarationEvent {
  final String token;

  const FetchDeclarationsEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

class FetchDeclarationByIdEvent extends DeclarationEvent {
  final String token;
  final String declarationId;

  const FetchDeclarationByIdEvent({
    required this.token,
    required this.declarationId,
  });

  @override
  List<Object?> get props => [token, declarationId];
}

class SaveDeclarationDraftEvent extends DeclarationEvent {
  final String token;
  final String declarationId;
  final Map<String, dynamic> answers;

  const SaveDeclarationDraftEvent({
    required this.token,
    required this.declarationId,
    required this.answers,
  });

  @override
  List<Object?> get props => [token, declarationId, answers];
}

class SubmitDeclarationEvent extends DeclarationEvent {
  final String token;
  final String declarationId;
  final Map<String, dynamic>? answers;

  const SubmitDeclarationEvent({
    required this.token,
    required this.declarationId,
    this.answers,
  });

  @override
  List<Object?> get props => [token, declarationId, answers];
}

class ReviseDeclarationEvent extends DeclarationEvent {
  final String token;
  final String declarationId;

  const ReviseDeclarationEvent({
    required this.token,
    required this.declarationId,
  });

  @override
  List<Object?> get props => [token, declarationId];
}

class PrintDeclarationEvent extends DeclarationEvent {
  final String token;
  final String declarationId;

  const PrintDeclarationEvent({
    required this.token,
    required this.declarationId,
  });

  @override
  List<Object?> get props => [token, declarationId];
}
