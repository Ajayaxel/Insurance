import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/request_otp_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/data/datasources/home_remote_data_source.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/usecases/get_home_overview_usecase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final httpClient = http.Client();
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
  );

  final loginUseCase = LoginUseCase(authRepository);
  final requestOtpUseCase = RequestOtpUseCase(authRepository);
  final verifyOtpUseCase = VerifyOtpUseCase(authRepository);

  runApp(MyApp(
    loginUseCase: loginUseCase,
    requestOtpUseCase: requestOtpUseCase,
    verifyOtpUseCase: verifyOtpUseCase,
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final AuthRepository authRepository;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        loginUseCase: loginUseCase,
        requestOtpUseCase: requestOtpUseCase,
        verifyOtpUseCase: verifyOtpUseCase,
        repository: authRepository,
      )..add(CheckAuthStatusEvent()),
      child: MaterialApp(
        title: 'Insurance Mobile App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitialState || state is AuthLoadingState) {
              return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Restoring session...',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is AuthAuthenticatedState) {
              final remoteDataSource = HomeRemoteDataSourceImpl(client: http.Client());
              final repository = HomeRepositoryImpl(remoteDataSource: remoteDataSource);
              final useCase = GetHomeOverviewUseCase(repository);

              return BlocProvider(
                create: (_) => HomeBloc(getHomeOverviewUseCase: useCase),
                child: HomePage(user: state.user),
              );
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
