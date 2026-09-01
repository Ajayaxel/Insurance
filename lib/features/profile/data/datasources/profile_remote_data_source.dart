import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile({required String token});

  Future<ProfileModel> updateProfile({
    required String token,
    String? name,
    String? email,
    String? phone,
    Map<String, dynamic>? profileDetails,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;

  ProfileRemoteDataSourceImpl({required this.client});

  Map<String, String> _buildHeaders(String token) {
    return {
      ...ApiConstants.defaultHeaders,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<ProfileModel> getProfile({required String token}) async {
    final url = ApiConstants.profile;
    final headers = _buildHeaders(token);

    if (kDebugMode) {
      debugPrint('\n=================== GET PROFILE API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('================================================================\n');
    }

    final response = await client.get(Uri.parse(url), headers: headers);

    if (kDebugMode) {
      debugPrint('\n------------------- GET PROFILE API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('================================================================\n');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      return ProfileModel.fromJson(decoded);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized access to profile.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to retrieve user profile.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    required String token,
    String? name,
    String? email,
    String? phone,
    Map<String, dynamic>? profileDetails,
  }) async {
    final url = ApiConstants.profile;
    final headers = _buildHeaders(token);

    final Map<String, dynamic> bodyMap = {};
    if (name != null) bodyMap['name'] = name;
    if (email != null) bodyMap['email'] = email;
    if (phone != null) bodyMap['phone'] = phone;
    if (profileDetails != null) bodyMap['profile'] = profileDetails;

    final requestBody = jsonEncode(bodyMap);

    if (kDebugMode) {
      debugPrint('\n=================== UPDATE PROFILE API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('Body: $requestBody');
      debugPrint('==================================================================\n');
    }

    final response = await client.patch(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- UPDATE PROFILE API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('==================================================================\n');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      return ProfileModel.fromJson(decoded);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized to update profile.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to update profile.',
        statusCode: response.statusCode,
      );
    }
  }
}
