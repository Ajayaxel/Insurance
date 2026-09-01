import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:http/http.dart' as http;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Session Restoration Tests', () {
    test('should retrieve cached user when token and cached data exist', () async {
      SharedPreferences.setMockInitialValues({
        kCachedAuthTokenKey: 'stored_jwt_token_123',
        kCachedUserKey: '{"id":"usr_001","email":"user@test.com","token":"stored_jwt_token_123","ctxType":"POLICYHOLDER"}',
      });

      final prefs = await SharedPreferences.getInstance();
      final localDataSource = AuthLocalDataSourceImpl(sharedPreferences: prefs);
      final repository = AuthRepositoryImpl(
        remoteDataSource: AuthRemoteDataSourceImpl(client: http.Client()),
        localDataSource: localDataSource,
      );

      final user = await repository.getSavedUser();

      expect(user, isNotNull);
      expect(user!.token, 'stored_jwt_token_123');
      expect(user.email, 'user@test.com');
      expect(user.ctxType, 'POLICYHOLDER');
    });

    test('should restore session using stored token when cached token key exists', () async {
      SharedPreferences.setMockInitialValues({
        kCachedAuthTokenKey: 'standalone_token_456',
      });

      final prefs = await SharedPreferences.getInstance();
      final localDataSource = AuthLocalDataSourceImpl(sharedPreferences: prefs);
      final repository = AuthRepositoryImpl(
        remoteDataSource: AuthRemoteDataSourceImpl(client: http.Client()),
        localDataSource: localDataSource,
      );

      final user = await repository.getSavedUser();

      expect(user, isNotNull);
      expect(user!.token, 'standalone_token_456');
    });

    test('should return null when no token is stored in local storage', () async {
      SharedPreferences.setMockInitialValues({});

      final prefs = await SharedPreferences.getInstance();
      final localDataSource = AuthLocalDataSourceImpl(sharedPreferences: prefs);
      final repository = AuthRepositoryImpl(
        remoteDataSource: AuthRemoteDataSourceImpl(client: http.Client()),
        localDataSource: localDataSource,
      );

      final user = await repository.getSavedUser();

      expect(user, isNull);
    });
  });
}
