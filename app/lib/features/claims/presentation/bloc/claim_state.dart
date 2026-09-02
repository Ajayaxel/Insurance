import 'package:equatable/equatable.dart';
import '../../domain/entities/claim_entity.dart';

abstract class ClaimState extends Equatable {
  const ClaimState();

  @override
  List<Object?> get props => [];
}

class ClaimInitialState extends ClaimState {}

class ClaimLoadingState extends ClaimState {}

class ClaimsLoadedState extends ClaimState {
  final List<ClaimEntity> claims;

  const ClaimsLoadedState({required this.claims});

  @override
  List<Object?> get props => [claims];
}

class ClaimSubmittedSuccessState extends ClaimState {
  final ClaimEntity claim;
  final String message;

  const ClaimSubmittedSuccessState({
    required this.claim,
    required this.message,
  });

  @override
  List<Object?> get props => [claim, message];
}

class ClaimErrorState extends ClaimState {
  final String message;

  const ClaimErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
