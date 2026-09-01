import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/declaration_model.dart';

abstract class DeclarationRemoteDataSource {
  Future<DeclarationFormSchemaModel> getDeclarationForm({
    required String token,
    required String category,
  });

  Future<List<DeclarationModel>> getDeclarations({
    required String token,
  });

  Future<DeclarationModel> getDeclarationById({
    required String token,
    required String declarationId,
  });

  Future<DeclarationModel> saveDeclarationDraft({
    required String token,
    required String declarationId,
    required Map<String, dynamic> answers,
  });

  Future<DeclarationModel> submitDeclaration({
    required String token,
    required String declarationId,
    Map<String, dynamic>? answers,
  });

  Future<DeclarationModel> reviseDeclaration({
    required String token,
    required String declarationId,
  });

  Future<String> printDeclaration({
    required String token,
    required String declarationId,
  });
}

class DeclarationRemoteDataSourceImpl implements DeclarationRemoteDataSource {
  final http.Client client;

  DeclarationRemoteDataSourceImpl({required this.client});

  Map<String, String> _buildHeaders(String token) {
    return {
      ...ApiConstants.defaultHeaders,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<DeclarationFormSchemaModel> getDeclarationForm({
    required String token,
    required String category,
  }) async {
    final url = ApiConstants.declarationForm(category);
    final headers = _buildHeaders(token);

    if (kDebugMode) {
      debugPrint('\n=================== GET DECLARATION FORM API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('========================================================================\n');
    }

    final response = await client.get(Uri.parse(url), headers: headers);

    if (kDebugMode) {
      debugPrint('\n------------------- GET DECLARATION FORM API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('========================================================================\n');
    }

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final jsonMap = decoded is Map<String, dynamic> ? decoded : {'schema': decoded};
      if (!jsonMap.containsKey('category')) {
        jsonMap['category'] = category;
      }
      return DeclarationFormSchemaModel.fromJson(jsonMap);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized access to declaration form.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to retrieve declaration form.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<List<DeclarationModel>> getDeclarations({
    required String token,
  }) async {
    final url = ApiConstants.declarations;
    final headers = _buildHeaders(token);

    if (kDebugMode) {
      debugPrint('\n=================== GET DECLARATIONS API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('====================================================================\n');
    }

    final response = await client.get(Uri.parse(url), headers: headers);

    if (kDebugMode) {
      debugPrint('\n------------------- GET DECLARATIONS API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('====================================================================\n');
    }

    if (response.statusCode == 200) {
      dynamic decodedResponseBody;
      try {
        decodedResponseBody = jsonDecode(response.body);
      } catch (e) {
        throw ServerException(
          'Failed to parse declarations response: ${response.body}',
          statusCode: response.statusCode,
        );
      }

      List<dynamic> rawList = [];
      if (decodedResponseBody is List) {
        rawList = decodedResponseBody;
      } else if (decodedResponseBody is Map<String, dynamic>) {
        if (decodedResponseBody['declarations'] is List) {
          rawList = decodedResponseBody['declarations'] as List;
        } else if (decodedResponseBody['data'] is List) {
          rawList = decodedResponseBody['data'] as List;
        }
      }

      return rawList
          .map((d) => DeclarationModel.fromJson(d as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized access to declarations.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to retrieve declarations.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<DeclarationModel> getDeclarationById({
    required String token,
    required String declarationId,
  }) async {
    final url = ApiConstants.declarationDetail(declarationId);
    final headers = _buildHeaders(token);

    if (kDebugMode) {
      debugPrint('\n=================== GET ONE DECLARATION API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('=======================================================================\n');
    }

    final response = await client.get(Uri.parse(url), headers: headers);

    if (kDebugMode) {
      debugPrint('\n------------------- GET ONE DECLARATION API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=======================================================================\n');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final declarationMap = decoded['declaration'] is Map<String, dynamic>
          ? decoded['declaration'] as Map<String, dynamic>
          : decoded;
      return DeclarationModel.fromJson(declarationMap);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized access to declaration.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to retrieve declaration detail.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<DeclarationModel> saveDeclarationDraft({
    required String token,
    required String declarationId,
    required Map<String, dynamic> answers,
  }) async {
    final url = ApiConstants.saveDeclarationDraft(declarationId);
    final headers = _buildHeaders(token);
    final requestBody = jsonEncode({'answers': answers});

    if (kDebugMode) {
      debugPrint('\n=================== SAVE DECLARATION DRAFT API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('Body: $requestBody');
      debugPrint('==========================================================================\n');
    }

    final response = await client.patch(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- SAVE DECLARATION DRAFT API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('==========================================================================\n');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final declarationMap = decoded['declaration'] is Map<String, dynamic>
          ? decoded['declaration'] as Map<String, dynamic>
          : decoded;
      return DeclarationModel.fromJson(declarationMap);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized to save declaration draft.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to save declaration draft.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<DeclarationModel> submitDeclaration({
    required String token,
    required String declarationId,
    Map<String, dynamic>? answers,
  }) async {
    final url = ApiConstants.submitDeclaration(declarationId);
    final headers = _buildHeaders(token);
    final requestBody = jsonEncode(answers != null ? {'answers': answers} : {});

    if (kDebugMode) {
      debugPrint('\n=================== SUBMIT DECLARATION API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('Body: $requestBody');
      debugPrint('======================================================================\n');
    }

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- SUBMIT DECLARATION API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('======================================================================\n');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final declarationMap = decoded['declaration'] is Map<String, dynamic>
          ? decoded['declaration'] as Map<String, dynamic>
          : decoded;
      return DeclarationModel.fromJson(declarationMap);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized to submit declaration.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to submit declaration.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<DeclarationModel> reviseDeclaration({
    required String token,
    required String declarationId,
  }) async {
    final url = ApiConstants.reviseDeclaration(declarationId);
    final headers = _buildHeaders(token);
    final requestBody = jsonEncode({});

    if (kDebugMode) {
      debugPrint('\n=================== REVISE DECLARATION API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('Body: $requestBody');
      debugPrint('======================================================================\n');
    }

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- REVISE DECLARATION API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('======================================================================\n');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final declarationMap = decoded['declaration'] is Map<String, dynamic>
          ? decoded['declaration'] as Map<String, dynamic>
          : decoded;
      return DeclarationModel.fromJson(declarationMap);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized to revise declaration.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to revise declaration.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<String> printDeclaration({
    required String token,
    required String declarationId,
  }) async {
    final url = ApiConstants.printDeclaration(declarationId);
    final headers = _buildHeaders(token);

    if (kDebugMode) {
      debugPrint('\n=================== PRINT DECLARATION API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('=====================================================================\n');
    }

    final response = await client.get(Uri.parse(url), headers: headers);

    if (kDebugMode) {
      debugPrint('\n------------------- PRINT DECLARATION API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=====================================================================\n');
    }

    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded['url'] ?? decoded['pdfUrl'] ?? decoded['documentUrl'] ?? response.body;
        }
      } catch (_) {}
      return response.body;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized to print declaration.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to print declaration.',
        statusCode: response.statusCode,
      );
    }
  }
}
