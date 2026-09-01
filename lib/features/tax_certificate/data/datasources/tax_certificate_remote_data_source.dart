import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/tax_certificate_model.dart';

abstract class TaxCertificateRemoteDataSource {
  Future<TaxCertificateModel> getTaxCertificate({
    required String token,
    String? financialYear,
  });
}

class TaxCertificateRemoteDataSourceImpl
    implements TaxCertificateRemoteDataSource {
  final http.Client client;

  TaxCertificateRemoteDataSourceImpl({required this.client});

  @override
  Future<TaxCertificateModel> getTaxCertificate({
    required String token,
    String? financialYear,
  }) async {
    Uri uri = Uri.parse(ApiConstants.taxCertificate);
    if (financialYear != null && financialYear.isNotEmpty) {
      uri = uri.replace(queryParameters: {'financialYear': financialYear});
    }

    final headers = {
      ...ApiConstants.defaultHeaders,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    if (kDebugMode) {
      debugPrint('\n=================== TAX CERTIFICATE API REQUEST ===================');
      debugPrint('URL: $uri');
      debugPrint('Headers: $headers');
      debugPrint('===================================================================\n');
    }

    final response = await client.get(
      uri,
      headers: headers,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- TAX CERTIFICATE API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('===================================================================\n');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponseBody = jsonDecode(response.body);
      return TaxCertificateModel.fromJson(jsonResponseBody);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized access to Tax Certificate.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to fetch tax certificate data.',
        statusCode: response.statusCode,
      );
    }
  }
}
