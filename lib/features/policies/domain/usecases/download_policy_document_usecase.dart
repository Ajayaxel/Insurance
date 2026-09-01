import 'dart:typed_data';
import '../repositories/policy_repository.dart';

class DownloadPolicyDocumentUseCase {
  final PolicyRepository repository;

  DownloadPolicyDocumentUseCase(this.repository);

  Future<Uint8List> call({
    required String token,
    required String policyId,
  }) async {
    return await repository.getPolicyDocumentBytes(
      token: token,
      policyId: policyId,
    );
  }
}
