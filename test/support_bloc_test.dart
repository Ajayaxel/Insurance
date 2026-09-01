import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/support/domain/entities/support_ticket_entity.dart';
import 'package:app/features/support/domain/repositories/support_repository.dart';
import 'package:app/features/support/domain/usecases/get_support_tickets_usecase.dart';
import 'package:app/features/support/domain/usecases/open_support_ticket_usecase.dart';
import 'package:app/features/support/presentation/bloc/support_bloc.dart';
import 'package:app/features/support/presentation/bloc/support_event.dart';
import 'package:app/features/support/presentation/bloc/support_state.dart';

class MockSupportRepository implements SupportRepository {
  final bool shouldFail;

  MockSupportRepository({this.shouldFail = false});

  @override
  Future<List<SupportTicketEntity>> getSupportTickets({required String token}) async {
    if (shouldFail) throw Exception('Failed to fetch support tickets');
    return const [
      SupportTicketEntity(
        id: 'tkt_1',
        subject: 'Update phone number',
        message: 'Please change to 98460 12345.',
        status: 'OPEN',
      ),
    ];
  }

  @override
  Future<SupportTicketEntity> openSupportTicket({
    required String token,
    required String subject,
    required String message,
  }) async {
    if (shouldFail) throw Exception('Failed to open ticket');
    return SupportTicketEntity(
      id: 'tkt_new',
      subject: subject,
      message: message,
      status: 'OPEN',
    );
  }
}

void main() {
  group('SupportBloc tests', () {
    late MockSupportRepository repository;
    late GetSupportTicketsUseCase getSupportTicketsUseCase;
    late OpenSupportTicketUseCase openSupportTicketUseCase;

    setUp(() {
      repository = MockSupportRepository();
      getSupportTicketsUseCase = GetSupportTicketsUseCase(repository);
      openSupportTicketUseCase = OpenSupportTicketUseCase(repository);
    });

    test('initial state should be SupportInitialState', () {
      final bloc = SupportBloc(
        getSupportTicketsUseCase: getSupportTicketsUseCase,
        openSupportTicketUseCase: openSupportTicketUseCase,
      );

      expect(bloc.state, isA<SupportInitialState>());
    });

    test('should emit [SupportLoadingState, SupportTicketsLoadedState] on FetchSupportTicketsEvent', () async {
      final bloc = SupportBloc(
        getSupportTicketsUseCase: getSupportTicketsUseCase,
        openSupportTicketUseCase: openSupportTicketUseCase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SupportLoadingState>(),
          isA<SupportTicketsLoadedState>().having((s) => s.tickets.length, 'length', 1),
        ]),
      );

      bloc.add(const FetchSupportTicketsEvent(token: 'mock_token'));
    });

    test('should emit [SupportLoadingState, SupportTicketCreatedSuccessState] on OpenSupportTicketEvent', () async {
      final bloc = SupportBloc(
        getSupportTicketsUseCase: getSupportTicketsUseCase,
        openSupportTicketUseCase: openSupportTicketUseCase,
      );

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<SupportLoadingState>(),
          isA<SupportTicketCreatedSuccessState>().having((s) => s.ticket.id, 'id', 'tkt_new'),
        ]),
      );

      bloc.add(const OpenSupportTicketEvent(
        token: 'mock_token',
        subject: 'Update email',
        message: 'Please change email',
      ));
    });
  });
}
