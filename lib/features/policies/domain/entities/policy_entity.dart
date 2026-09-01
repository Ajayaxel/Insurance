import 'package:equatable/equatable.dart';

class PolicyEntity extends Equatable {
  final String id;
  final String policyNumber;
  final String type;
  final String status;
  final String? planName;
  final num? insuredAmountInr;
  final num? premiumAmountInr;
  final String? startDate;
  final String? endDate;
  final String? insurerName;

  const PolicyEntity({
    required this.id,
    required this.policyNumber,
    required this.type,
    required this.status,
    this.planName,
    this.insuredAmountInr,
    this.premiumAmountInr,
    this.startDate,
    this.endDate,
    this.insurerName,
  });

  bool get isActive => status.toUpperCase() == 'ACTIVE';

  @override
  List<Object?> get props => [
        id,
        policyNumber,
        type,
        status,
        planName,
        insuredAmountInr,
        premiumAmountInr,
        startDate,
        endDate,
        insurerName,
      ];
}
