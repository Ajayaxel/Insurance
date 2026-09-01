import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource? localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<UserEntity> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.loginWithEmail(
        email: email,
        password: password,
      );
      if (localDataSource != null) {
        await localDataSource!.saveUser(user);
      }
      return user;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> loginWithRegistration({
    required String registrationNumber,
    required String password,
    required String orgSlug,
  }) async {
    try {
      final user = await remoteDataSource.loginWithRegistration(
        registrationNumber: registrationNumber,
        password: password,
        orgSlug: orgSlug,
      );
      if (localDataSource != null) {
        await localDataSource!.saveUser(user);
      }
      return user;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> requestOtp({
    required String phone,
    required String orgSlug,
  }) async {
    try {
      await remoteDataSource.requestOtp(phone: phone, orgSlug: orgSlug);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException('Failed to request OTP: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> verifyOtp({
    required String phone,
    required String orgSlug,
    required String code,
  }) async {
    try {
      final user = await remoteDataSource.verifyOtp(
        phone: phone,
        orgSlug: orgSlug,
        code: code,
      );
      if (localDataSource != null) {
        await localDataSource!.saveUser(user);
      }
      return user;
    } on AuthException catch (e) {
      throw AuthException(e.message);
    } on ServerException catch (e) {
      throw ServerException(e.message, statusCode: e.statusCode);
    } catch (e) {
      throw ServerException('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity?> getSavedUser() async {
    if (localDataSource == null) return null;
    final user = await localDataSource!.getCachedUser();
    return user;
  }

  @override
  Future<void> logout() async {
    if (localDataSource != null) {
      await localDataSource!.clearAuthData();
    }
  }
}
