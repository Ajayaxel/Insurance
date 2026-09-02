import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/errors/exceptions.dart';
import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';
import 'package:app/features/auth/domain/usecases/login_usecase.dart';
import 'package:app/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:app/features/auth/presentation/bloc/auth_event.dart';
import 'package:app/features/auth/presentation/bloc/auth_state.dart';

class MockAuthRepository implements AuthRepository {
  final bool shouldFail;
  final String errorMessage;

  MockAuthRepository({this.shouldFail = false, this.errorMessage = 'Invalid credentials'});

  @override
  Future<UserEntity> loginWithEmail({required String email, required String password}) async {
    if (shouldFail) {
      throw AuthException(errorMessage);
    }
    return const UserEntity(
      id: 'usr_1',
      email: 'test@example.com',
      name: 'Test User',
      ctxType: 'POLICYHOLDER',
      token: 'jwt_token',
    );
  }

  @override
  Future<UserEntity> loginWithRegistration({
    required String registrationNumber,
    required String password,
    required String orgSlug,
  }) async {
    if (shouldFail) {
      throw AuthException(errorMessage);
    }
    return const UserEntity(
      id: 'usr_1',
      email: 'test@example.com',
      name: 'Test User',
      ctxType: 'POLICYHOLDER',
      token: 'jwt_token',
    );
  }

  @override
  Future<void> requestOtp({required String phone, required String orgSlug}) async {
    if (shouldFail) {
      throw ServerException(errorMessage, statusCode: 400);
    }
  }

  @override
  Future<UserEntity> verifyOtp({required String phone, required String orgSlug, required String code}) async {
    if (shouldFail) {
      throw AuthException(errorMessage);
    }
    return const UserEntity(
      id: 'usr_1',
      email: 'test@example.com',
      name: 'Test User',
      ctxType: 'POLICYHOLDER',
      token: 'jwt_token',
    );
  }

  @override
  Future<UserEntity?> getSavedUser() async {
    return null;
  }

  @override
  Future<void> logout() async {}
}

void main() {
  group('AuthBloc Unit Tests', () {
    test('Initial state is AuthInitialState', () {
      final repository = MockAuthRepository();
      final bloc = AuthBloc(
        loginUseCase: LoginUseCase(repository),
        requestOtpUseCase: RequestOtpUseCase(repository),
        verifyOtpUseCase: VerifyOtpUseCase(repository),
        repository: repository,
      );

      expect(bloc.state, isA<AuthInitialState>());
    });

    test('Emits [AuthLoadingState, AuthFailureState] when login fails with 401 AuthException', () async {
      final repository = MockAuthRepository(shouldFail: true, errorMessage: 'Invalid credentials');
      final bloc = AuthBloc(
        loginUseCase: LoginUseCase(repository),
        requestOtpUseCase: RequestOtpUseCase(repository),
        verifyOtpUseCase: VerifyOtpUseCase(repository),
        repository: repository,
      );

      final expectedStates = [
        isA<AuthLoadingState>(),
        predicate<AuthState>((state) {
          return state is AuthFailureState && state.errorMessage == 'Invalid credentials';
        }),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LoginWithEmailSubmittedEvent(
        email: 'policyholder@bmninsurance.test',
        password: 'wrongpassword',
      ));
    });
  });
}
