import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/claim_model.dart';

abstract class ClaimRemoteDataSource {
  Future<List<ClaimModel>> getClaims({required String token});

  Future<ClaimModel> raiseClaim({
    required String token,
    required String policyId,
    required String incidentDate,
    required String description,
    required num estimatedAmountInr,
  });

  Future<ClaimModel> attachClaimDocs({
    required String token,
    required String claimId,
    required List<ClaimDocumentModel> documents,
  });
}

class ClaimRemoteDataSourceImpl implements ClaimRemoteDataSource {
  final http.Client client;

  ClaimRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ClaimModel>> getClaims({required String token}) async {
    final url = ApiConstants.claims;
    final headers = {
      ...ApiConstants.defaultHeaders,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    if (kDebugMode) {
      debugPrint('\n=================== GET CLAIMS API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('==============================================================\n');
    }

    final response = await client.get(Uri.parse(url), headers: headers);

    if (kDebugMode) {
      debugPrint('\n------------------- GET CLAIMS API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('==============================================================\n');
    }

    if (response.statusCode == 200) {
      dynamic decodedResponseBody;
      try {
        decodedResponseBody = jsonDecode(response.body);
      } catch (e) {
        throw ServerException('Failed to parse claims response: ${response.body}', statusCode: response.statusCode);
      }

      List<dynamic> rawList = [];
      if (decodedResponseBody is List) {
        rawList = decodedResponseBody;
      } else if (decodedResponseBody is Map<String, dynamic>) {
        if (decodedResponseBody['claims'] is List) {
          rawList = decodedResponseBody['claims'] as List;
        } else if (decodedResponseBody['data'] is List) {
          rawList = decodedResponseBody['data'] as List;
        }
      }

      return rawList
          .map((c) => ClaimModel.fromJson(c as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized access to claims.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to retrieve claims.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<ClaimModel> raiseClaim({
    required String token,
    required String policyId,
    required String incidentDate,
    required String description,
    required num estimatedAmountInr,
  }) async {
    final url = ApiConstants.raiseClaim(policyId);
    final headers = {
      ...ApiConstants.defaultHeaders,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final requestBody = jsonEncode({
      'incidentDate': incidentDate,
      'description': description,
      'estimatedAmountInr': estimatedAmountInr,
    });

    if (kDebugMode) {
      debugPrint('\n=================== RAISE CLAIM API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('Body: $requestBody');
      debugPrint('===============================================================\n');
    }

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- RAISE CLAIM API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('===============================================================\n');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponseBody = jsonDecode(response.body);
      final claimMap = jsonResponseBody['claim'] is Map<String, dynamic>
          ? jsonResponseBody['claim'] as Map<String, dynamic>
          : jsonResponseBody;
      return ClaimModel.fromJson(claimMap);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized to raise claim.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to raise claim.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<ClaimModel> attachClaimDocs({
    required String token,
    required String claimId,
    required List<ClaimDocumentModel> documents,
  }) async {
    final url = ApiConstants.attachClaimDocs(claimId);
    final headers = {
      ...ApiConstants.defaultHeaders,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final requestBody = jsonEncode({
      'documents': documents.map((d) => d.toJson()).toList(),
    });

    if (kDebugMode) {
      debugPrint('\n=================== ATTACH CLAIM DOCS API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('Body: $requestBody');
      debugPrint('=====================================================================\n');
    }

    final response = await client.patch(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- ATTACH CLAIM DOCS API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=====================================================================\n');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponseBody = jsonDecode(response.body);
      final claimMap = jsonResponseBody['claim'] is Map<String, dynamic>
          ? jsonResponseBody['claim'] as Map<String, dynamic>
          : jsonResponseBody;
      return ClaimModel.fromJson(claimMap);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized to attach claim documents.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to attach claim documents.',
        statusCode: response.statusCode,
      );
    }
  }
}
