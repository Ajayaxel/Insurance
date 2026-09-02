import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class OtpSentState extends AuthState {
  final String phone;
  final String orgSlug;

  const OtpSentState({
    required this.phone,
    required this.orgSlug,
  });

  @override
  List<Object?> get props => [phone, orgSlug];
}

class AuthAuthenticatedState extends AuthState {
  final UserEntity user;

  const AuthAuthenticatedState({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticatedState extends AuthState {}

class AuthFailureState extends AuthState {
  final String errorMessage;

  const AuthFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
