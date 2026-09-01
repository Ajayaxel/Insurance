import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/support_ticket_model.dart';

abstract class SupportRemoteDataSource {
  Future<List<SupportTicketModel>> getSupportTickets({required String token});

  Future<SupportTicketModel> openSupportTicket({
    required String token,
    required String subject,
    required String message,
  });
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  final http.Client client;

  SupportRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SupportTicketModel>> getSupportTickets({required String token}) async {
    final url = ApiConstants.support;
    final headers = {
      ...ApiConstants.defaultHeaders,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };

    if (kDebugMode) {
      debugPrint('\n=================== GET SUPPORT TICKETS API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('=======================================================================\n');
    }

    final response = await client.get(Uri.parse(url), headers: headers);

    if (kDebugMode) {
      debugPrint('\n------------------- GET SUPPORT TICKETS API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=======================================================================\n');
    }

    if (response.statusCode == 200) {
      dynamic decodedResponseBody;
      try {
        decodedResponseBody = jsonDecode(response.body);
      } catch (e) {
        throw ServerException('Failed to parse support tickets response: ${response.body}', statusCode: response.statusCode);
      }

      List<dynamic> rawList = [];
      if (decodedResponseBody is List) {
        rawList = decodedResponseBody;
      } else if (decodedResponseBody is Map<String, dynamic>) {
        if (decodedResponseBody['tickets'] is List) {
          rawList = decodedResponseBody['tickets'] as List;
        } else if (decodedResponseBody['data'] is List) {
          rawList = decodedResponseBody['data'] as List;
        } else if (decodedResponseBody['support'] is List) {
          rawList = decodedResponseBody['support'] as List;
        }
      }

      return rawList
          .map((t) => SupportTicketModel.fromJson(t as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized access to support tickets.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to retrieve support tickets.',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<SupportTicketModel> openSupportTicket({
    required String token,
    required String subject,
    required String message,
  }) async {
    final url = ApiConstants.support;
    final headers = {
      ...ApiConstants.defaultHeaders,
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final requestBody = jsonEncode({
      'subject': subject,
      'message': message,
    });

    if (kDebugMode) {
      debugPrint('\n=================== OPEN SUPPORT TICKET API REQUEST ===================');
      debugPrint('URL: $url');
      debugPrint('Headers: $headers');
      debugPrint('Body: $requestBody');
      debugPrint('=======================================================================\n');
    }

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    if (kDebugMode) {
      debugPrint('\n------------------- OPEN SUPPORT TICKET API RESPONSE ------------------');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');
      debugPrint('=======================================================================\n');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonResponseBody = jsonDecode(response.body);
      final ticketMap = jsonResponseBody['ticket'] is Map<String, dynamic>
          ? jsonResponseBody['ticket'] as Map<String, dynamic>
          : jsonResponseBody;
      return SupportTicketModel.fromJson(ticketMap);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw AuthException('Unauthorized to open support ticket.');
    } else {
      Map<String, dynamic> body = {};
      try {
        body = jsonDecode(response.body);
      } catch (_) {}
      throw ServerException(
        body['message'] ?? 'Failed to open support ticket.',
        statusCode: response.statusCode,
      );
    }
  }
}
