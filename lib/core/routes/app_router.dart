import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/claims/data/datasources/claim_remote_data_source.dart';
import '../../features/claims/data/repositories/claim_repository_impl.dart';
import '../../features/claims/domain/usecases/attach_claim_docs_usecase.dart';
import '../../features/claims/domain/usecases/get_claims_usecase.dart';
import '../../features/claims/domain/usecases/raise_claim_usecase.dart';
import '../../features/claims/presentation/bloc/claim_bloc.dart';
import '../../features/claims/presentation/pages/claims_page.dart';
import '../../features/declarations/data/datasources/declaration_remote_data_source.dart';
import '../../features/declarations/data/repositories/declaration_repository_impl.dart';
import '../../features/declarations/domain/usecases/get_declaration_by_id_usecase.dart';
import '../../features/declarations/domain/usecases/get_declaration_form_usecase.dart';
import '../../features/declarations/domain/usecases/get_declarations_usecase.dart';
import '../../features/declarations/domain/usecases/print_declaration_usecase.dart';
import '../../features/declarations/domain/usecases/revise_declaration_usecase.dart';
import '../../features/declarations/domain/usecases/save_declaration_draft_usecase.dart';
import '../../features/declarations/domain/usecases/submit_declaration_usecase.dart';
import '../../features/declarations/presentation/bloc/declaration_bloc.dart';
import '../../features/declarations/presentation/pages/declarations_page.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/usecases/get_home_overview_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/policies/data/datasources/policy_remote_data_source.dart';
import '../../features/policies/data/repositories/policy_repository_impl.dart';
import '../../features/policies/domain/usecases/download_policy_document_usecase.dart';
import '../../features/policies/domain/usecases/get_policies_usecase.dart';
import '../../features/policies/domain/usecases/get_policy_documents_list_usecase.dart';
import '../../features/policies/presentation/bloc/policy_bloc.dart';
import '../../features/policies/presentation/pages/policies_page.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/support/data/datasources/support_remote_data_source.dart';
import '../../features/support/data/repositories/support_repository_impl.dart';
import '../../features/support/domain/usecases/get_support_tickets_usecase.dart';
import '../../features/support/domain/usecases/open_support_ticket_usecase.dart';
import '../../features/support/presentation/bloc/support_bloc.dart';
import '../../features/support/presentation/pages/support_page.dart';
import '../../features/tax_certificate/data/datasources/tax_certificate_remote_data_source.dart';
import '../../features/tax_certificate/data/repositories/tax_certificate_repository_impl.dart';
import '../../features/tax_certificate/domain/usecases/get_tax_certificate_usecase.dart';
import '../../features/tax_certificate/presentation/bloc/tax_certificate_bloc.dart';
import '../../features/tax_certificate/presentation/pages/tax_certificate_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String taxCertificate = '/tax-certificate';
  static const String policies = '/policies';
  static const String claims = '/claims';
  static const String declarations = '/declarations';
  static const String support = '/support';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.home:
        final user = settings.arguments as UserEntity?;
        if (user != null) {
          final remoteDataSource = HomeRemoteDataSourceImpl(client: http.Client());
          final repository = HomeRepositoryImpl(remoteDataSource: remoteDataSource);
          final useCase = GetHomeOverviewUseCase(repository);

          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => HomeBloc(getHomeOverviewUseCase: useCase),
              child: HomePage(user: user),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('User session not found for ${settings.name}'),
            ),
          ),
        );

      case AppRoutes.profile:
        final String token = (settings.arguments as String?) ?? '';
        final remoteDataSource = ProfileRemoteDataSourceImpl(client: http.Client());
        final repository = ProfileRepositoryImpl(remoteDataSource: remoteDataSource);

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ProfileBloc(
              getProfileUseCase: GetProfileUseCase(repository),
              updateProfileUseCase: UpdateProfileUseCase(repository),
            ),
            child: ProfilePage(token: token),
          ),
        );

      case AppRoutes.taxCertificate:
        final String token = (settings.arguments as String?) ?? '';
        final remoteDataSource = TaxCertificateRemoteDataSourceImpl(client: http.Client());
        final repository = TaxCertificateRepositoryImpl(remoteDataSource: remoteDataSource);
        final useCase = GetTaxCertificateUseCase(repository);

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => TaxCertificateBloc(getTaxCertificateUseCase: useCase),
            child: TaxCertificatePage(token: token),
          ),
        );

      case AppRoutes.policies:
        final String token = (settings.arguments as String?) ?? '';
        final remoteDataSource = PolicyRemoteDataSourceImpl(client: http.Client());
        final repository = PolicyRepositoryImpl(remoteDataSource: remoteDataSource);
        final getPoliciesUseCase = GetPoliciesUseCase(repository);
        final downloadDocUseCase = DownloadPolicyDocumentUseCase(repository);
        final getDocsListUseCase = GetPolicyDocumentsListUseCase(repository);

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PolicyBloc(
              getPoliciesUseCase: getPoliciesUseCase,
              downloadPolicyDocumentUseCase: downloadDocUseCase,
              getPolicyDocumentsListUseCase: getDocsListUseCase,
            ),
            child: PoliciesPage(token: token),
          ),
        );

      case AppRoutes.claims:
        final String token = (settings.arguments as String?) ?? '';
        final remoteDataSource = ClaimRemoteDataSourceImpl(client: http.Client());
        final repository = ClaimRepositoryImpl(remoteDataSource: remoteDataSource);
        final getClaimsUseCase = GetClaimsUseCase(repository);
        final raiseClaimUseCase = RaiseClaimUseCase(repository);
        final attachClaimDocsUseCase = AttachClaimDocsUseCase(repository);

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ClaimBloc(
              getClaimsUseCase: getClaimsUseCase,
              raiseClaimUseCase: raiseClaimUseCase,
              attachClaimDocsUseCase: attachClaimDocsUseCase,
            ),
            child: ClaimsPage(token: token),
          ),
        );

      case AppRoutes.declarations:
        final String token = (settings.arguments as String?) ?? '';
        final remoteDataSource = DeclarationRemoteDataSourceImpl(client: http.Client());
        final repository = DeclarationRepositoryImpl(remoteDataSource: remoteDataSource);

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DeclarationBloc(
              getDeclarationFormUseCase: GetDeclarationFormUseCase(repository),
              getDeclarationsUseCase: GetDeclarationsUseCase(repository),
              getDeclarationByIdUseCase: GetDeclarationByIdUseCase(repository),
              saveDeclarationDraftUseCase: SaveDeclarationDraftUseCase(repository),
              submitDeclarationUseCase: SubmitDeclarationUseCase(repository),
              reviseDeclarationUseCase: ReviseDeclarationUseCase(repository),
              printDeclarationUseCase: PrintDeclarationUseCase(repository),
            ),
            child: DeclarationsPage(token: token),
          ),
        );

      case AppRoutes.support:
        final String token = (settings.arguments as String?) ?? '';
        final remoteDataSource = SupportRemoteDataSourceImpl(client: http.Client());
        final repository = SupportRepositoryImpl(remoteDataSource: remoteDataSource);
        final getSupportTicketsUseCase = GetSupportTicketsUseCase(repository);
        final openSupportTicketUseCase = OpenSupportTicketUseCase(repository);

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SupportBloc(
              getSupportTicketsUseCase: getSupportTicketsUseCase,
              openSupportTicketUseCase: openSupportTicketUseCase,
            ),
            child: SupportPage(token: token),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('404 - Page Not Found'),
            ),
          ),
        );
    }
  }
}
