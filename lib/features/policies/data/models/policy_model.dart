import '../../domain/entities/policy_entity.dart';

class PolicyModel extends PolicyEntity {
  const PolicyModel({
    required super.id,
    required super.policyNumber,
    required super.type,
    required super.status,
    super.planName,
    super.insuredAmountInr,
    super.premiumAmountInr,
    super.startDate,
    super.endDate,
    super.insurerName,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      id: (json['id'] ?? json['_id'] ?? json['policyId'] ?? '').toString(),
      policyNumber: (json['policyNumber'] ??
              json['number'] ??
              json['code'] ??
              json['id'] ??
              'POL-UNKNOWN')
          .toString(),
      type: (json['type'] ?? json['category'] ?? json['policyType'] ?? 'GENERAL')
          .toString(),
      status: (json['status'] ?? json['state'] ?? 'ACTIVE').toString(),
      planName: json['planName']?.toString() ??
          json['name']?.toString() ??
          json['title']?.toString() ??
          json['productName']?.toString(),
      insuredAmountInr: (json['insuredAmountInr'] ??
          json['sumInsured'] ??
          json['coverageAmount']) as num?,
      premiumAmountInr:
          (json['premiumAmountInr'] ?? json['premium'] ?? json['amount']) as num?,
      startDate: json['startDate']?.toString() ??
          json['effectiveDate']?.toString() ??
          json['from']?.toString(),
      endDate: json['endDate']?.toString() ??
          json['expiryDate']?.toString() ??
          json['to']?.toString(),
      insurerName: json['insurerName']?.toString() ??
          json['provider']?.toString() ??
          json['company']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'policyNumber': policyNumber,
      'type': type,
      'status': status,
      'planName': planName,
      'insuredAmountInr': insuredAmountInr,
      'premiumAmountInr': premiumAmountInr,
      'startDate': startDate,
      'endDate': endDate,
      'insurerName': insurerName,
    };
  }
}
