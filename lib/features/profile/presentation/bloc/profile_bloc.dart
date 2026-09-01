import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitialState()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    try {
      final profile = await getProfileUseCase(token: event.token);
      emit(ProfileLoadedState(profile));
    } catch (e) {
      emit(ProfileErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());
    try {
      final updatedProfile = await updateProfileUseCase(
        token: event.token,
        name: event.name,
        email: event.email,
        phone: event.phone,
        profileDetails: event.profileDetails,
      );
      emit(ProfileUpdatedState(profile: updatedProfile));
    } catch (e) {
      emit(ProfileErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
