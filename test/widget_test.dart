import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:app/features/auth/domain/usecases/login_usecase.dart';
import 'package:app/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:app/features/home/presentation/pages/home_page.dart';
import 'package:app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App loads Policyholder Login Page smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final pref = await SharedPreferences.getInstance();
    final localDataSource = AuthLocalDataSourceImpl(sharedPreferences: pref);
    final client = http.Client();
    final remoteDataSource = AuthRemoteDataSourceImpl(client: client);
    final repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
    final loginUseCase = LoginUseCase(repository);
    final requestOtpUseCase = RequestOtpUseCase(repository);
    final verifyOtpUseCase = VerifyOtpUseCase(repository);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      loginUseCase: loginUseCase,
      requestOtpUseCase: requestOtpUseCase,
      verifyOtpUseCase: verifyOtpUseCase,
      authRepository: repository,
    ));

    await tester.pumpAndSettle();

    // Verify that login title is found.
    expect(find.text('Policyholder Portal'), findsOneWidget);
  });

  testWidgets('HomePage renders user info and active policy card', (WidgetTester tester) async {
    const testUser = UserEntity(
      id: 'usr_1001',
      email: 'test@example.com',
      name: 'John Doe',
      ctxType: 'POLICYHOLDER',
      token: 'jwt_mock_token_abc123',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(user: testUser),
      ),
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Policyholder Dashboard Overview'), findsOneWidget);
    expect(find.text('My Policies'), findsOneWidget);
    expect(find.text('File a Claim'), findsOneWidget);
  });
}
