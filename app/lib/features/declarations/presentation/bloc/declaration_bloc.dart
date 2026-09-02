import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_declaration_by_id_usecase.dart';
import '../../domain/usecases/get_declaration_form_usecase.dart';
import '../../domain/usecases/get_declarations_usecase.dart';
import '../../domain/usecases/print_declaration_usecase.dart';
import '../../domain/usecases/revise_declaration_usecase.dart';
import '../../domain/usecases/save_declaration_draft_usecase.dart';
import '../../domain/usecases/submit_declaration_usecase.dart';
import 'declaration_event.dart';
import 'declaration_state.dart';

class DeclarationBloc extends Bloc<DeclarationEvent, DeclarationState> {
  final GetDeclarationFormUseCase getDeclarationFormUseCase;
  final GetDeclarationsUseCase getDeclarationsUseCase;
  final GetDeclarationByIdUseCase getDeclarationByIdUseCase;
  final SaveDeclarationDraftUseCase saveDeclarationDraftUseCase;
  final SubmitDeclarationUseCase submitDeclarationUseCase;
  final ReviseDeclarationUseCase? reviseDeclarationUseCase;
  final PrintDeclarationUseCase? printDeclarationUseCase;

  DeclarationBloc({
    required this.getDeclarationFormUseCase,
    required this.getDeclarationsUseCase,
    required this.getDeclarationByIdUseCase,
    required this.saveDeclarationDraftUseCase,
    required this.submitDeclarationUseCase,
    this.reviseDeclarationUseCase,
    this.printDeclarationUseCase,
  }) : super(DeclarationInitialState()) {
    on<FetchDeclarationFormEvent>(_onFetchDeclarationForm);
    on<FetchDeclarationsEvent>(_onFetchDeclarations);
    on<FetchDeclarationByIdEvent>(_onFetchDeclarationById);
    on<SaveDeclarationDraftEvent>(_onSaveDeclarationDraft);
    on<SubmitDeclarationEvent>(_onSubmitDeclaration);
    on<ReviseDeclarationEvent>(_onReviseDeclaration);
    on<PrintDeclarationEvent>(_onPrintDeclaration);
  }

  Future<void> _onFetchDeclarationForm(
    FetchDeclarationFormEvent event,
    Emitter<DeclarationState> emit,
  ) async {
    emit(DeclarationLoadingState());
    try {
      final schemaEntity = await getDeclarationFormUseCase(
        token: event.token,
        category: event.category,
      );
      emit(DeclarationFormLoadedState(schemaEntity));
    } catch (e) {
      emit(DeclarationErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onFetchDeclarations(
    FetchDeclarationsEvent event,
    Emitter<DeclarationState> emit,
  ) async {
    emit(DeclarationLoadingState());
    try {
      final declarations = await getDeclarationsUseCase(token: event.token);
      emit(DeclarationsLoadedState(declarations));
    } catch (e) {
      emit(DeclarationErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onFetchDeclarationById(
    FetchDeclarationByIdEvent event,
    Emitter<DeclarationState> emit,
  ) async {
    emit(DeclarationLoadingState());
    try {
      final declaration = await getDeclarationByIdUseCase(
        token: event.token,
        declarationId: event.declarationId,
      );
      emit(DeclarationDetailLoadedState(declaration));
    } catch (e) {
      emit(DeclarationErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSaveDeclarationDraft(
    SaveDeclarationDraftEvent event,
    Emitter<DeclarationState> emit,
  ) async {
    try {
      final updatedDeclaration = await saveDeclarationDraftUseCase(
        token: event.token,
        declarationId: event.declarationId,
        answers: event.answers,
      );
      emit(DeclarationSavedState(updatedDeclaration));
    } catch (e) {
      emit(DeclarationErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSubmitDeclaration(
    SubmitDeclarationEvent event,
    Emitter<DeclarationState> emit,
  ) async {
    emit(DeclarationLoadingState());
    try {
      final submittedDeclaration = await submitDeclarationUseCase(
        token: event.token,
        declarationId: event.declarationId,
        answers: event.answers,
      );
      emit(DeclarationSubmittedState(submittedDeclaration));
    } catch (e) {
      emit(DeclarationErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onReviseDeclaration(
    ReviseDeclarationEvent event,
    Emitter<DeclarationState> emit,
  ) async {
    emit(DeclarationLoadingState());
    try {
      if (reviseDeclarationUseCase == null) {
        throw Exception('ReviseDeclarationUseCase is not initialized.');
      }
      final newRevision = await reviseDeclarationUseCase!(
        token: event.token,
        declarationId: event.declarationId,
      );
      emit(DeclarationRevisedState(newRevision));
    } catch (e) {
      emit(DeclarationErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onPrintDeclaration(
    PrintDeclarationEvent event,
    Emitter<DeclarationState> emit,
  ) async {
    emit(DeclarationLoadingState());
    try {
      if (printDeclarationUseCase == null) {
        throw Exception('PrintDeclarationUseCase is not initialized.');
      }
      final pdfUrl = await printDeclarationUseCase!(
        token: event.token,
        declarationId: event.declarationId,
      );
      emit(DeclarationPrintedState(pdfUrl));
    } catch (e) {
      emit(DeclarationErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
