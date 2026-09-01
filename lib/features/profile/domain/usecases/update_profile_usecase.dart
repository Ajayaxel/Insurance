import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<ProfileEntity> call({
    required String token,
    String? name,
    String? email,
    String? phone,
    Map<String, dynamic>? profileDetails,
  }) async {
    return await repository.updateProfile(
      token: token,
      name: name,
      email: email,
      phone: phone,
      profileDetails: profileDetails,
    );
  }
}
