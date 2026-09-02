import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/declarations/domain/entities/declaration_entity.dart';
import 'package:app/features/declarations/domain/repositories/declaration_repository.dart';
import 'package:app/features/declarations/domain/usecases/get_declaration_by_id_usecase.dart';
import 'package:app/features/declarations/domain/usecases/get_declaration_form_usecase.dart';
import 'package:app/features/declarations/domain/usecases/get_declarations_usecase.dart';
import 'package:app/features/declarations/domain/usecases/print_declaration_usecase.dart';
import 'package:app/features/declarations/domain/usecases/revise_declaration_usecase.dart';
import 'package:app/features/declarations/domain/usecases/save_declaration_draft_usecase.dart';
import 'package:app/features/declarations/domain/usecases/submit_declaration_usecase.dart';
import 'package:app/features/declarations/presentation/bloc/declaration_bloc.dart';
import 'package:app/features/declarations/presentation/bloc/declaration_event.dart';
import 'package:app/features/declarations/presentation/bloc/declaration_state.dart';

class MockDeclarationRepository implements DeclarationRepository {
  final bool shouldFail;

  MockDeclarationRepository({this.shouldFail = false});

  @override
  Future<DeclarationFormSchemaEntity> getDeclarationForm({
    required String token,
    required String category,
  }) async {
    if (shouldFail) throw Exception('Failed to fetch form schema');
    return DeclarationFormSchemaEntity(
      category: category,
      title: '$category Questionnaire',
      schema: const {'type': 'object'},
    );
  }

  @override
  Future<List<DeclarationEntity>> getDeclarations({
    required String token,
  }) async {
    if (shouldFail) throw Exception('Failed to fetch declarations');
    return const [
      DeclarationEntity(
        id: 'decl_1',
        category: 'health',
        status: 'DRAFT',
        answers: {'tobacco': false},
      ),
    ];
  }

  @override
  Future<DeclarationEntity> getDeclarationById({
    required String token,
    required String declarationId,
  }) async {
    if (shouldFail) throw Exception('Failed to fetch declaration');
    return DeclarationEntity(
      id: declarationId,
      category: 'health',
      status: 'DRAFT',
      answers: const {'tobacco': false},
    );
  }

  @override
  Future<DeclarationEntity> saveDeclarationDraft({
    required String token,
    required String declarationId,
    required Map<String, dynamic> answers,
  }) async {
    if (shouldFail) throw Exception('Failed to save draft');
    return DeclarationEntity(
      id: declarationId,
      category: 'health',
      status: 'DRAFT',
      answers: answers,
    );
  }

  @override
  Future<DeclarationEntity> submitDeclaration({
    required String token,
    required String declarationId,
    Map<String, dynamic>? answers,
  }) async {
    if (shouldFail) throw Exception('Failed to submit declaration');
    return DeclarationEntity(
      id: declarationId,
      category: 'health',
      status: 'SUBMITTED',
      answers: answers ?? const {'tobacco': false},
    );
  }

  @override
  Future<DeclarationEntity> reviseDeclaration({
    required String token,
    required String declarationId,
  }) async {
    if (shouldFail) throw Exception('Failed to revise declaration');
    return DeclarationEntity(
      id: '${declarationId}_v2',
      category: 'health',
      status: 'DRAFT',
      answers: const {'tobacco': false},
    );
  }

  @override
  Future<String> printDeclaration({
    required String token,
    required String declarationId,
  }) async {
    if (shouldFail) throw Exception('Failed to print declaration');
    return 'https://example.com/declarations/$declarationId/print.pdf';
  }
}

void main() {
  group('DeclarationBloc tests', () {
    DeclarationBloc createBloc({bool shouldFail = false}) {
      final repo = MockDeclarationRepository(shouldFail: shouldFail);
      return DeclarationBloc(
        getDeclarationFormUseCase: GetDeclarationFormUseCase(repo),
        getDeclarationsUseCase: GetDeclarationsUseCase(repo),
        getDeclarationByIdUseCase: GetDeclarationByIdUseCase(repo),
        saveDeclarationDraftUseCase: SaveDeclarationDraftUseCase(repo),
        submitDeclarationUseCase: SubmitDeclarationUseCase(repo),
        reviseDeclarationUseCase: ReviseDeclarationUseCase(repo),
        printDeclarationUseCase: PrintDeclarationUseCase(repo),
      );
    }

    test('initial state should be DeclarationInitialState', () {
      final bloc = createBloc();
      expect(bloc.state, isA<DeclarationInitialState>());
    });

    test('should emit [DeclarationLoadingState, DeclarationFormLoadedState] on FetchDeclarationFormEvent', () async {
      final bloc = createBloc();

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DeclarationLoadingState>(),
          isA<DeclarationFormLoadedState>().having(
            (s) => s.schemaEntity.category,
            'category',
            'health',
          ),
        ]),
      );

      bloc.add(const FetchDeclarationFormEvent(token: 'test_token', category: 'health'));
    });

    test('should emit [DeclarationLoadingState, DeclarationsLoadedState] on FetchDeclarationsEvent', () async {
      final bloc = createBloc();

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DeclarationLoadingState>(),
          isA<DeclarationsLoadedState>().having(
            (s) => s.declarations.length,
            'length',
            1,
          ),
        ]),
      );

      bloc.add(const FetchDeclarationsEvent(token: 'test_token'));
    });

    test('should emit [DeclarationSavedState] on SaveDeclarationDraftEvent', () async {
      final bloc = createBloc();

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DeclarationSavedState>().having(
            (s) => s.declaration.answers['tobacco'],
            'tobacco',
            false,
          ),
        ]),
      );

      bloc.add(const SaveDeclarationDraftEvent(
        token: 'test_token',
        declarationId: 'decl_1',
        answers: {'tobacco': false},
      ));
    });

    test('should emit [DeclarationLoadingState, DeclarationSubmittedState] on SubmitDeclarationEvent', () async {
      final bloc = createBloc();

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DeclarationLoadingState>(),
          isA<DeclarationSubmittedState>().having(
            (s) => s.declaration.status,
            'status',
            'SUBMITTED',
          ),
        ]),
      );

      bloc.add(const SubmitDeclarationEvent(
        token: 'test_token',
        declarationId: 'decl_1',
      ));
    });

    test('should emit [DeclarationLoadingState, DeclarationRevisedState] on ReviseDeclarationEvent', () async {
      final bloc = createBloc();

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DeclarationLoadingState>(),
          isA<DeclarationRevisedState>().having(
            (s) => s.newRevision.id,
            'id',
            'decl_1_v2',
          ),
        ]),
      );

      bloc.add(const ReviseDeclarationEvent(
        token: 'test_token',
        declarationId: 'decl_1',
      ));
    });

    test('should emit [DeclarationLoadingState, DeclarationPrintedState] on PrintDeclarationEvent', () async {
      final bloc = createBloc();

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DeclarationLoadingState>(),
          isA<DeclarationPrintedState>().having(
            (s) => s.pdfUrl,
            'pdfUrl',
            'https://example.com/declarations/decl_1/print.pdf',
          ),
        ]),
      );

      bloc.add(const PrintDeclarationEvent(
        token: 'test_token',
        declarationId: 'decl_1',
      ));
    });

    test('should emit [DeclarationLoadingState, DeclarationErrorState] when repository throws exception', () async {
      final bloc = createBloc(shouldFail: true);

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DeclarationLoadingState>(),
          isA<DeclarationErrorState>().having(
            (s) => s.message,
            'message',
            'Failed to fetch declarations',
          ),
        ]),
      );

      bloc.add(const FetchDeclarationsEvent(token: 'test_token'));
    });
  });
}
