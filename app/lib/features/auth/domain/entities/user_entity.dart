import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String ctxType; // e.g. POLICYHOLDER or INSURANCE_AGENT
  final String token;
  final String? organizationId;
  final String? studentId;
  final String? guardianId;
  final String? facultyId;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    required this.ctxType,
    required this.token,
    this.organizationId,
    this.studentId,
    this.guardianId,
    this.facultyId,
  });

  bool get isAgent => ctxType == 'INSURANCE_AGENT';

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phone,
        ctxType,
        token,
        organizationId,
        studentId,
        guardianId,
        facultyId,
      ];
}
