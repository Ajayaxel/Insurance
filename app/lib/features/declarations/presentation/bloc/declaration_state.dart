import 'package:equatable/equatable.dart';
import '../../domain/entities/declaration_entity.dart';

abstract class DeclarationState extends Equatable {
  const DeclarationState();

  @override
  List<Object?> get props => [];
}

class DeclarationInitialState extends DeclarationState {}

class DeclarationLoadingState extends DeclarationState {}

class DeclarationFormLoadedState extends DeclarationState {
  final DeclarationFormSchemaEntity schemaEntity;

  const DeclarationFormLoadedState(this.schemaEntity);

  @override
  List<Object?> get props => [schemaEntity];
}

class DeclarationsLoadedState extends DeclarationState {
  final List<DeclarationEntity> declarations;

  const DeclarationsLoadedState(this.declarations);

  @override
  List<Object?> get props => [declarations];
}

class DeclarationDetailLoadedState extends DeclarationState {
  final DeclarationEntity declaration;

  const DeclarationDetailLoadedState(this.declaration);

  @override
  List<Object?> get props => [declaration];
}

class DeclarationSavedState extends DeclarationState {
  final DeclarationEntity declaration;

  const DeclarationSavedState(this.declaration);

  @override
  List<Object?> get props => [declaration];
}

class DeclarationSubmittedState extends DeclarationState {
  final DeclarationEntity declaration;

  const DeclarationSubmittedState(this.declaration);

  @override
  List<Object?> get props => [declaration];
}

class DeclarationRevisedState extends DeclarationState {
  final DeclarationEntity newRevision;

  const DeclarationRevisedState(this.newRevision);

  @override
  List<Object?> get props => [newRevision];
}

class DeclarationPrintedState extends DeclarationState {
  final String pdfUrl;

  const DeclarationPrintedState(this.pdfUrl);

  @override
  List<Object?> get props => [pdfUrl];
}

class DeclarationErrorState extends DeclarationState {
  final String message;

  const DeclarationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
