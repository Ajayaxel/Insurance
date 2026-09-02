import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpParams extends Equatable {
  final String phone;
  final String orgSlug;
  final String code;

  const VerifyOtpParams({
    required this.phone,
    required this.orgSlug,
    required this.code,
  });

  @override
  List<Object?> get props => [phone, orgSlug, code];
}

class VerifyOtpUseCase implements UseCase<UserEntity, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<UserEntity> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(
      phone: params.phone,
      orgSlug: params.orgSlug,
      code: params.code,
    );
  }
}
