import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String type;
  final Map<String, dynamic> profileDetails;

  const ProfileEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
    required this.profileDetails,
  });

  @override
  List<Object?> get props => [name, email, phone, type, profileDetails];
}
