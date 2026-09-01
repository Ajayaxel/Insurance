import 'dart:typed_data';
import '../entities/policy_document_entity.dart';
import '../entities/policy_entity.dart';

abstract class PolicyRepository {
  /// Fetches policyholder's list of policies
  Future<List<PolicyEntity>> getPolicies({required String token});

  /// Downloads policy PDF binary document bytes for specified policyId
  Future<Uint8List> getPolicyDocumentBytes({
    required String token,
    required String policyId,
  });

  /// Fetches list of all associated policy attachments/documents
  Future<List<PolicyDocumentEntity>> getPolicyDocumentsList({
    required String token,
    required String policyId,
  });
}
