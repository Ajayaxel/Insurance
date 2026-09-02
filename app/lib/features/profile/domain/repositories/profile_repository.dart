import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  /// Fetches policyholder profile
  Future<ProfileEntity> getProfile({required String token});

  /// Updates policyholder profile
  Future<ProfileEntity> updateProfile({
    required String token,
    String? name,
    String? email,
    String? phone,
    Map<String, dynamic>? profileDetails,
  });
}
