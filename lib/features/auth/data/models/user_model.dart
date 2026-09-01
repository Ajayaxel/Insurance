import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.phone,
    required super.ctxType,
    required super.token,
    super.organizationId,
    super.studentId,
    super.guardianId,
    super.facultyId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Standard portal auth login response layout
    final userMap = json['user'] as Map<String, dynamic>? ?? json;
    final String portalToken = (json['accessToken'] ??
            json['token'] ??
            json['portalToken'] ??
            userMap['token'] ??
            userMap['accessToken'] ??
            '')
        .toString();

    final String extractedCtxType = (userMap['type'] ??
            userMap['ctx']?['type'] ??
            userMap['ctxType'] ??
            userMap['role'] ??
            'POLICYHOLDER')
        .toString();

    return UserModel(
      id: (userMap['id'] ?? userMap['_id'] ?? '').toString(),
      email: (userMap['email'] ?? '').toString(),
      name: userMap['name']?.toString(),
      phone: userMap['phone']?.toString(),
      ctxType: extractedCtxType,
      token: portalToken,
      organizationId: userMap['organizationId']?.toString(),
      studentId: userMap['studentId']?.toString(),
      guardianId: userMap['guardianId']?.toString(),
      facultyId: userMap['facultyId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'ctxType': ctxType,
      'type': ctxType,
      'token': token,
      'accessToken': token,
      'organizationId': organizationId,
      'studentId': studentId,
      'guardianId': guardianId,
      'facultyId': facultyId,
    };
  }
}
