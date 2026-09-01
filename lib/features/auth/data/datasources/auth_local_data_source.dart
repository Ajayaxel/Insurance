import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Save authentication token to persistent storage
  Future<void> saveToken(String token);

  /// Retrieve stored authentication token
  Future<String?> getToken();

  /// Save cached user details to persistent storage
  Future<void> saveUser(UserModel user);

  /// Retrieve cached user details
  Future<UserModel?> getCachedUser();

  /// Clear all stored authentication token & cached user data
  Future<void> clearAuthData();
}

const String kCachedAuthTokenKey = 'CACHED_AUTH_TOKEN';
const String kCachedUserKey = 'CACHED_USER_DATA';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(kCachedAuthTokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(kCachedAuthTokenKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJsonString = jsonEncode(user.toJson());
    await sharedPreferences.setString(kCachedUserKey, userJsonString);
    if (user.token.isNotEmpty) {
      await saveToken(user.token);
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJsonString = sharedPreferences.getString(kCachedUserKey);
    final storedToken = sharedPreferences.getString(kCachedAuthTokenKey);

    if (userJsonString != null && userJsonString.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(userJsonString);
        final String existingToken = (jsonMap['accessToken'] ?? jsonMap['token'] ?? jsonMap['portalToken'] ?? '').toString();
        if (existingToken.isEmpty && storedToken != null && storedToken.isNotEmpty) {
          jsonMap['accessToken'] = storedToken;
          jsonMap['token'] = storedToken;
        }
        return UserModel.fromJson(jsonMap);
      } catch (_) {}
    }

    if (storedToken != null && storedToken.isNotEmpty) {
      return UserModel(
        id: 'cached_session_user',
        email: 'policyholder@insurance.app',
        token: storedToken,
        ctxType: 'POLICYHOLDER',
      );
    }

    return null;
  }

  @override
  Future<void> clearAuthData() async {
    await sharedPreferences.remove(kCachedAuthTokenKey);
    await sharedPreferences.remove(kCachedUserKey);
  }
}
