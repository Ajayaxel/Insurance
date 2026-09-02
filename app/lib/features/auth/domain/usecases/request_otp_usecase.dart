import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class RequestOtpParams extends Equatable {
  final String phone;
  final String orgSlug;

  const RequestOtpParams({
    required this.phone,
    required this.orgSlug,
  });

  @override
  List<Object?> get props => [phone, orgSlug];
}

class RequestOtpUseCase implements UseCase<void, RequestOtpParams> {
  final AuthRepository repository;

  RequestOtpUseCase(this.repository);

  @override
  Future<void> call(RequestOtpParams params) async {
    return await repository.requestOtp(
      phone: params.phone,
      orgSlug: params.orgSlug,
    );
  }
}
