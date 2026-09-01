class ApiConstants {
  static const String baseUrl =
      'https://api-staging-staging-0772.up.railway.app/api';

  // Auth Endpoints
  static const String login = '$baseUrl/portal/auth/login';
  static const String otpRequest = '$baseUrl/portal/auth/otp/request';
  static const String otpVerify = '$baseUrl/portal/auth/otp/verify';
  static const String me = '$baseUrl/portal/auth/me';

  // Policyholder Endpoints
  static const String overview = '$baseUrl/portal/me/insurance/overview';
  static const String policies = '$baseUrl/portal/me/insurance/policies';
  static String policyDocument(String policyId) =>
      '$baseUrl/portal/me/insurance/policies/$policyId/document';
  static String policyDocumentsList(String policyId) =>
      '$baseUrl/portal/me/insurance/policies/$policyId/documents';
  static const String claims = '$baseUrl/portal/me/insurance/claims';
  static String raiseClaim(String policyId) =>
      '$baseUrl/portal/me/insurance/policies/$policyId/claims';
  static String attachClaimDocs(String claimId) =>
      '$baseUrl/portal/me/insurance/claims/$claimId/docs';
  static const String support = '$baseUrl/portal/me/insurance/support';
  static const String profile = '$baseUrl/portal/me/insurance/profile';
  static const String taxCertificate =
      '$baseUrl/portal/me/insurance/tax-certificate';

  // Declarations Endpoints
  static String declarationForm(String category) =>
      '$baseUrl/portal/me/insurance/declarations/form?category=$category';
  static const String declarations =
      '$baseUrl/portal/me/insurance/declarations';
  static String declarationDetail(String declarationId) =>
      '$baseUrl/portal/me/insurance/declarations/$declarationId';
  static String saveDeclarationDraft(String declarationId) =>
      '$baseUrl/portal/me/insurance/declarations/$declarationId';
  static String submitDeclaration(String declarationId) =>
      '$baseUrl/portal/me/insurance/declarations/$declarationId/submit';
  static String reviseDeclaration(String declarationId) =>
      '$baseUrl/portal/me/insurance/declarations/$declarationId/revise';
  static String printDeclaration(String declarationId) =>
      '$baseUrl/portal/me/insurance/declarations/$declarationId/print';

  // Agent Endpoints
  static const String agentProfile =
      '$baseUrl/portal/me/insurance-agent/profile';
  static const String agentBusiness =
      '$baseUrl/portal/me/insurance-agent/business';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
