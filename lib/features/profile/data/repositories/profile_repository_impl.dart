import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileEntity> getProfile({required String token}) async {
    return await remoteDataSource.getProfile(token: token);
  }

  @override
  Future<ProfileEntity> updateProfile({
    required String token,
    String? name,
    String? email,
    String? phone,
    Map<String, dynamic>? profileDetails,
  }) async {
    return await remoteDataSource.updateProfile(
      token: token,
      name: name,
      email: email,
      phone: phone,
      profileDetails: profileDetails,
    );
  }
}
