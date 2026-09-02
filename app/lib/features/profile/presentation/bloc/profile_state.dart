import 'package:equatable/equatable.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoadedState(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdatedState extends ProfileState {
  final ProfileEntity profile;
  final String message;

  const ProfileUpdatedState({
    required this.profile,
    this.message = 'Profile updated successfully!',
  });

  @override
  List<Object?> get props => [profile, message];
}

class ProfileErrorState extends ProfileState {
  final String message;

  const ProfileErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
