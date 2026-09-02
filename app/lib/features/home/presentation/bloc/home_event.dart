import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchHomeOverviewEvent extends HomeEvent {
  final String token;

  const FetchHomeOverviewEvent({required this.token});

  @override
  List<Object?> get props => [token];
}
