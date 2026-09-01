import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfileEvent extends ProfileEvent {
  final String token;

  const FetchProfileEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

class UpdateProfileEvent extends ProfileEvent {
  final String token;
  final String? name;
  final String? email;
  final String? phone;
  final Map<String, dynamic>? profileDetails;

  const UpdateProfileEvent({
    required this.token,
    this.name,
    this.email,
    this.phone,
    this.profileDetails,
  });

  @override
  List<Object?> get props => [token, name, email, phone, profileDetails];
}
