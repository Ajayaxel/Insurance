import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Policyholder or Agent login via Email + Password
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });

  /// Policyholder login via Registration Number + Password + OrgSlug
  Future<UserModel> loginWithRegistration({
    required String registrationNumber,
    required String password,
    required String orgSlug,
  });

  /// Request OTP Code for Phone Number + OrgSlug
  Future<void> requestOtp({
    required String phone,
    required String orgSlug,
  });

  /// Verify OTP Code for Phone Number + OrgSlug + Code
  Future<UserModel> verifyOtp({
    required String phone,
    required String orgSlug,
    required String code,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  void _logRequestResponse({
    required String endpoint,
    required Map<String, dynamic> requestBody,
    required http.Response response,
  }) {
    if (kDebugMode) {
      debugPrint('\n=================== API REQUEST ===================');
      debugPrint('URL: $endpoint');
      debugPrint('Headers: ${ApiConstants.defaultHeaders}');
      debugPrint('Request Body: ${jsonEncode(requestBody)}');
      debugPrint('------------------- API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('===================================================\n');
    }
  }

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final url = ApiConstants.login;
    final requestBody = {
      'email': email,
      'password': password,
    };

    final response = await client.post(
      Uri.parse(url),
      headers: ApiConstants.defaultHeaders,
      body: jsonEncode(requestBody),
    );

    _logRequestResponse(
      endpoint: url,
      requestBody: requestBody,
      response: response,
    );

    return _parseUserResponse(response);
  }

  @override
  Future<UserModel> loginWithRegistration({
    required String registrationNumber,
    required String password,
    required String orgSlug,
  }) async {
    final url = ApiConstants.login;
    final requestBody = {
      'registrationNumber': registrationNumber,
      'password': password,
      'orgSlug': orgSlug,
    };

    final response = await client.post(
      Uri.parse(url),
      headers: ApiConstants.defaultHeaders,
      body: jsonEncode(requestBody),
    );

    _logRequestResponse(
      endpoint: url,
      requestBody: requestBody,
      response: response,
    );

    return _parseUserResponse(response);
  }

  @override
  Future<void> requestOtp({
    required String phone,
    required String orgSlug,
  }) async {
    final url = ApiConstants.otpRequest;
    final requestBody = {
      'phone': phone,
      'orgSlug': orgSlug,
    };

    final response = await client.post(
      Uri.parse(url),
      headers: ApiConstants.defaultHeaders,
      body: jsonEncode(requestBody),
    );

    _logRequestResponse(
      endpoint: url,
      requestBody: requestBody,
      response: response,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to send OTP. Please check phone and org slug.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<UserModel> verifyOtp({
    required String phone,
    required String orgSlug,
    required String code,
  }) async {
    final url = ApiConstants.otpVerify;
    final requestBody = {
      'phone': phone,
      'orgSlug': orgSlug,
      'code': code,
    };

    final response = await client.post(
      Uri.parse(url),
      headers: ApiConstants.defaultHeaders,
      body: jsonEncode(requestBody),
    );

    _logRequestResponse(
      endpoint: url,
      requestBody: requestBody,
      response: response,
    );

    return _parseUserResponse(response);
  }

  UserModel _parseUserResponse(http.Response response) {
    Map<String, dynamic> jsonResponseBody = {};
    try {
      jsonResponseBody = jsonDecode(response.body);
    } catch (e) {
      throw ServerException('Failed to parse JSON response: ${response.body}', statusCode: response.statusCode);
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(jsonResponseBody);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException(jsonResponseBody['message'] ?? 'Invalid credentials or unauthorized access.');
    } else {
      throw ServerException(
        jsonResponseBody['message'] ?? 'Server error occurred during authentication.',
        statusCode: response.statusCode,
      );
    }
  }
}
