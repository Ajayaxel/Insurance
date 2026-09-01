import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_overview_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeOverviewUseCase getHomeOverviewUseCase;

  HomeBloc({required this.getHomeOverviewUseCase}) : super(HomeInitialState()) {
    on<FetchHomeOverviewEvent>(_onFetchHomeOverview);
  }

  Future<void> _onFetchHomeOverview(
    FetchHomeOverviewEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    try {
      final overview = await getHomeOverviewUseCase(token: event.token);
      emit(HomeOverviewLoadedState(overview: overview));
    } catch (e) {
      emit(HomeErrorState(
        e.toString().replaceAll('Exception: ', '').replaceAll('ServerException: ', ''),
      ));
    }
  }
}
