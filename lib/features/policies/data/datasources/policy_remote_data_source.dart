import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/policy_document_model.dart';
import '../models/policy_model.dart';

abstract class PolicyRemoteDataSource {
  Future<List<PolicyModel>> getPolicies({required String token});
  Future<Uint8List> getPolicyDocumentBytes({
    required String token,
    required String policyId,
  });
  Future<List<PolicyDocumentModel>> getPolicyDocumentsList({
    required String token,
    required String policyId,
  });
}

class PolicyRemoteDataSourceImpl implements PolicyRemoteDataSource {
  final http.Client client;

  PolicyRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PolicyModel>> getPolicies({required String token}) async {
    final url = ApiConstants.policies;
    final headers = {
      ...ApiConstants.defaultHeaders,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    if (kDebugMode) {
      debugPrint('\n=================== GET POLICIES API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('================================================================\n');
    }

    final response = await client.get(
      Uri.parse(url),
      headers: headers,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- GET POLICIES API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('================================================================\n');
    }

    if (response.statusCode == 200) {
      dynamic decodedResponseBody;
      try {
        decodedResponseBody = jsonDecode(response.body);
      } catch (e) {
        throw ServerException('Failed to parse policies response: ${response.body}', statusCode: response.statusCode);
      }

      List<dynamic> rawList = [];
      if (decodedResponseBody is List) {
        rawList = decodedResponseBody;
      } else if (decodedResponseBody is Map<String, dynamic>) {
        if (decodedResponseBody['policies'] is List) {
          rawList = decodedResponseBody['policies'] as List;
        } else if (decodedResponseBody['data'] is List) {
          rawList = decodedResponseBody['data'] as List;
        } else if (decodedResponseBody['items'] is List) {
          rawList = decodedResponseBody['items'] as List;
        }
      }

      return rawList
          .map((item) => PolicyModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized access to policies.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to retrieve policies list from server.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<Uint8List> getPolicyDocumentBytes({
    required String token,
    required String policyId,
  }) async {
    final url = ApiConstants.policyDocument(policyId);
    final headers = {
      'Accept': 'application/pdf, application/json, */*',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    if (kDebugMode) {
      debugPrint('\n=================== POLICY DOCUMENT API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('===================================================================\n');
    }

    final response = await client.get(
      Uri.parse(url),
      headers: headers,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- POLICY DOCUMENT API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Bytes: ${response.bodyBytes.length} bytes');
      debugPrint('===================================================================\n');
    }

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized access to policy document.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to download policy document PDF.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<List<PolicyDocumentModel>> getPolicyDocumentsList({
    required String token,
    required String policyId,
  }) async {
    final url = ApiConstants.policyDocumentsList(policyId);
    final headers = {
      ...ApiConstants.defaultHeaders,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    if (kDebugMode) {
      debugPrint('\n=================== POLICY DOCUMENTS LIST API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('=========================================================================\n');
    }

    final response = await client.get(
      Uri.parse(url),
      headers: headers,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- POLICY DOCUMENTS LIST API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=========================================================================\n');
    }

    if (response.statusCode == 200) {
      dynamic decodedResponseBody;
      try {
        decodedResponseBody = jsonDecode(response.body);
      } catch (e) {
        throw ServerException('Failed to parse policy documents response: ${response.body}', statusCode: response.statusCode);
      }

      List<dynamic> rawList = [];
      if (decodedResponseBody is List) {
        rawList = decodedResponseBody;
      } else if (decodedResponseBody is Map<String, dynamic>) {
        if (decodedResponseBody['documents'] is List) {
          rawList = decodedResponseBody['documents'] as List;
        } else if (decodedResponseBody['data'] is List) {
          rawList = decodedResponseBody['data'] as List;
        } else if (decodedResponseBody['items'] is List) {
          rawList = decodedResponseBody['items'] as List;
        }
      }

      return rawList
          .map((doc) => PolicyDocumentModel.fromJson(doc as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized access to policy documents.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to retrieve policy documents list.',
        statusCode: response.statusCode,
      );
    }
  }
}
