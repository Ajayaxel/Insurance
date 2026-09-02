import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.name,
    required super.email,
    required super.phone,
    required super.type,
    required super.profileDetails,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> profileMap = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;

    return ProfileModel(
      name: profileMap['name']?.toString() ?? '',
      email: profileMap['email']?.toString() ?? '',
      phone: profileMap['phone']?.toString() ?? '',
      type: profileMap['type']?.toString() ?? 'INDIVIDUAL',
      profileDetails: (profileMap['profile'] is Map<String, dynamic>)
          ? Map<String, dynamic>.from(profileMap['profile'] as Map)
          : <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'type': type,
      'profile': profileDetails,
    };
  }
}
