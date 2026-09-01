import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/profile/domain/entities/profile_entity.dart';
import 'package:app/features/profile/domain/repositories/profile_repository.dart';
import 'package:app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:app/features/profile/presentation/bloc/profile_event.dart';
import 'package:app/features/profile/presentation/bloc/profile_state.dart';

class MockProfileRepository implements ProfileRepository {
  final bool shouldFail;

  MockProfileRepository({this.shouldFail = false});

  @override
  Future<ProfileEntity> getProfile({required String token}) async {
    if (shouldFail) throw Exception('Failed to fetch profile');
    return const ProfileEntity(
      name: 'Rajesh Menon',
      email: 'rajesh.menon@example.com',
      phone: '9846012001',
      type: 'INDIVIDUAL',
      profileDetails: {},
    );
  }

  @override
  Future<ProfileEntity> updateProfile({
    required String token,
    String? name,
    String? email,
    String? phone,
    Map<String, dynamic>? profileDetails,
  }) async {
    if (shouldFail) throw Exception('Failed to update profile');
    return ProfileEntity(
      name: name ?? 'Rajesh Menon',
      email: email ?? 'rajesh.menon@example.com',
      phone: phone ?? '9846012001',
      type: 'INDIVIDUAL',
      profileDetails: profileDetails ?? const {},
    );
  }
}

void main() {
  group('ProfileBloc tests', () {
    ProfileBloc createBloc({bool shouldFail = false}) {
      final repo = MockProfileRepository(shouldFail: shouldFail);
      return ProfileBloc(
        getProfileUseCase: GetProfileUseCase(repo),
        updateProfileUseCase: UpdateProfileUseCase(repo),
      );
    }

    test('initial state should be ProfileInitialState', () {
      final bloc = createBloc();
      expect(bloc.state, isA<ProfileInitialState>());
    });

    test('should emit [ProfileLoadingState, ProfileLoadedState] on FetchProfileEvent', () async {
      final bloc = createBloc();

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProfileLoadingState>(),
          isA<ProfileLoadedState>().having(
            (s) => s.profile.email,
            'email',
            'rajesh.menon@example.com',
          ),
        ]),
      );

      bloc.add(const FetchProfileEvent(token: 'mock_token'));
    });

    test('should emit [ProfileLoadingState, ProfileUpdatedState] on UpdateProfileEvent', () async {
      final bloc = createBloc();

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProfileLoadingState>(),
          isA<ProfileUpdatedState>().having(
            (s) => s.profile.phone,
            'phone',
            '9846012001',
          ),
        ]),
      );

      bloc.add(const UpdateProfileEvent(
        token: 'mock_token',
        phone: '9846012001',
        email: 'rajesh.menon@example.com',
      ));
    });

    test('should emit [ProfileLoadingState, ProfileErrorState] when repository throws exception', () async {
      final bloc = createBloc(shouldFail: true);

      expectLater(
        bloc.stream,
        emitsInOrder([
          isA<ProfileLoadingState>(),
          isA<ProfileErrorState>().having(
            (s) => s.message,
            'message',
            'Failed to fetch profile',
          ),
        ]),
      );

      bloc.add(const FetchProfileEvent(token: 'mock_token'));
    });
  });
}
