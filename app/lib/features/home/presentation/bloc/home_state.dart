import 'package:equatable/equatable.dart';
import '../../domain/entities/home_overview_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeOverviewLoadedState extends HomeState {
  final HomeOverviewEntity overview;

  const HomeOverviewLoadedState({required this.overview});

  @override
  List<Object?> get props => [overview];
}

class HomeErrorState extends HomeState {
  final String message;

  const HomeErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
