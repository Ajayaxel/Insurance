import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/request_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final AuthRepository repository;

  AuthBloc({
    required this.loginUseCase,
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.repository,
  }) : super(AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginWithEmailSubmittedEvent>(_onLoginWithEmail);
    on<LoginWithRegistrationSubmittedEvent>(_onLoginWithRegistration);
    on<RequestOtpSubmittedEvent>(_onRequestOtp);
    on<VerifyOtpSubmittedEvent>(_onVerifyOtp);
    on<LogoutRequestedEvent>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final savedUser = await repository.getSavedUser();
      if (savedUser != null && savedUser.token.isNotEmpty) {
        emit(AuthAuthenticatedState(user: savedUser));
      } else {
        emit(AuthUnauthenticatedState());
      }
    } catch (_) {
      emit(AuthUnauthenticatedState());
    }
  }

  Future<void> _onLoginWithEmail(
    LoginWithEmailSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = await loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );
      emit(AuthAuthenticatedState(user: user));
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoginWithRegistration(
    LoginWithRegistrationSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = await repository.loginWithRegistration(
        registrationNumber: event.registrationNumber,
        password: event.password,
        orgSlug: event.orgSlug,
      );
      emit(AuthAuthenticatedState(user: user));
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRequestOtp(
    RequestOtpSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await requestOtpUseCase(
        RequestOtpParams(phone: event.phone, orgSlug: event.orgSlug),
      );
      emit(OtpSentState(phone: event.phone, orgSlug: event.orgSlug));
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = await verifyOtpUseCase(
        VerifyOtpParams(
          phone: event.phone,
          orgSlug: event.orgSlug,
          code: event.code,
        ),
      );
      emit(AuthAuthenticatedState(user: user));
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    await repository.logout();
    emit(AuthUnauthenticatedState());
  }
}
