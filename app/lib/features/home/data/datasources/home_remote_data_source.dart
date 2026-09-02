import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/home_overview_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeOverviewModel> getHomeOverview({required String token});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final http.Client client;

  HomeRemoteDataSourceImpl({required this.client});

  @override
  Future<HomeOverviewModel> getHomeOverview({required String token}) async {
    final url = ApiConstants.overview;
    final headers = {
      ...ApiConstants.defaultHeaders,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    if (kDebugMode) {
      debugPrint('\n=================== HOME OVERVIEW API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('=================================================================\n');
    }

    final response = await client.get(
      Uri.parse(url),
      headers: headers,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- HOME OVERVIEW API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=================================================================\n');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponseBody = jsonDecode(response.body);
      return HomeOverviewModel.fromJson(jsonResponseBody);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized access to home overview.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to retrieve home dashboard overview.',
        statusCode: response.statusCode,
      );
    }
  }
}
