import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/home/domain/entities/home_overview_entity.dart';
import 'package:app/features/home/domain/repositories/home_repository.dart';
import 'package:app/features/home/domain/usecases/get_home_overview_usecase.dart';
import 'package:app/features/home/presentation/bloc/home_bloc.dart';
import 'package:app/features/home/presentation/bloc/home_event.dart';
import 'package:app/features/home/presentation/bloc/home_state.dart';

class MockHomeRepository implements HomeRepository {
  final bool shouldFail;

  MockHomeRepository({this.shouldFail = false});

  @override
  Future<HomeOverviewEntity> getHomeOverview({required String token}) async {
    if (shouldFail) {
      throw Exception('Failed to connect to home overview endpoint');
    }
    return const HomeOverviewEntity(
      client: ClientEntity(
        name: 'Rajesh Menon',
        email: 'rajesh.menon@example.com',
        phone: '9846012001',
        type: 'INDIVIDUAL',
      ),
      currency: 'INR',
      kpis: KpisEntity(
        activePolicies: 1,
        totalSumInsuredInr: 500000,
        annualPremiumInr: 12000,
        openClaims: 0,
      ),
      renewalAlerts: [],
      policies: [],
      claims: [],
      support: [],
    );
  }
}

void main() {
  group('HomeBloc tests', () {
    test('initial state should be HomeInitialState', () {
      final repository = MockHomeRepository();
      final useCase = GetHomeOverviewUseCase(repository);
      final bloc = HomeBloc(getHomeOverviewUseCase: useCase);

      expect(bloc.state, isA<HomeInitialState>());
    });

    test('should emit [HomeLoadingState, HomeOverviewLoadedState] when API call succeeds', () async {
      final repository = MockHomeRepository();
      final useCase = GetHomeOverviewUseCase(repository);
      final bloc = HomeBloc(getHomeOverviewUseCase: useCase);

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HomeLoadingState>(),
          isA<HomeOverviewLoadedState>().having(
            (s) => s.overview.client.name,
            'client name',
            'Rajesh Menon',
          ),
        ]),
      );

      bloc.add(const FetchHomeOverviewEvent(token: 'mock_token'));
    });

    test('should emit [HomeLoadingState, HomeErrorState] when API call fails', () async {
      final repository = MockHomeRepository(shouldFail: true);
      final useCase = GetHomeOverviewUseCase(repository);
      final bloc = HomeBloc(getHomeOverviewUseCase: useCase);

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HomeLoadingState>(),
          isA<HomeErrorState>(),
        ]),
      );

      bloc.add(const FetchHomeOverviewEvent(token: 'mock_token'));
    });
  });
}
