import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserEntity> loginWithRegistration({
    required String registrationNumber,
    required String password,
    required String orgSlug,
  });

  Future<void> requestOtp({
    required String phone,
    required String orgSlug,
  });

  Future<UserEntity> verifyOtp({
    required String phone,
    required String orgSlug,
    required String code,
  });

  Future<UserEntity?> getSavedUser();

  Future<void> logout();
}

