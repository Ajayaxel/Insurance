import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginWithEmailSubmittedEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailSubmittedEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class LoginWithRegistrationSubmittedEvent extends AuthEvent {
  final String registrationNumber;
  final String password;
  final String orgSlug;

  const LoginWithRegistrationSubmittedEvent({
    required this.registrationNumber,
    required this.password,
    required this.orgSlug,
  });

  @override
  List<Object?> get props => [registrationNumber, password, orgSlug];
}

class RequestOtpSubmittedEvent extends AuthEvent {
  final String phone;
  final String orgSlug;

  const RequestOtpSubmittedEvent({
    required this.phone,
    required this.orgSlug,
  });

  @override
  List<Object?> get props => [phone, orgSlug];
}

class VerifyOtpSubmittedEvent extends AuthEvent {
  final String phone;
  final String orgSlug;
  final String code;

  const VerifyOtpSubmittedEvent({
    required this.phone,
    required this.orgSlug,
    required this.code,
  });

  @override
  List<Object?> get props => [phone, orgSlug, code];
}

class LogoutRequestedEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

