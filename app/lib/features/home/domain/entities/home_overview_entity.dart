import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String type;

  const ClientEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
  });

  @override
  List<Object?> get props => [name, email, phone, type];
}

class KpisEntity extends Equatable {
  final num activePolicies;
  final num totalSumInsuredInr;
  final num annualPremiumInr;
  final num openClaims;

  const KpisEntity({
    required this.activePolicies,
    required this.totalSumInsuredInr,
    required this.annualPremiumInr,
    required this.openClaims,
  });

  @override
  List<Object?> get props => [
        activePolicies,
        totalSumInsuredInr,
        annualPremiumInr,
        openClaims,
      ];
}

class HomeOverviewEntity extends Equatable {
  final ClientEntity client;
  final String currency;
  final KpisEntity kpis;
  final List<dynamic> renewalAlerts;
  final List<dynamic> policies;
  final List<dynamic> claims;
  final List<dynamic> support;

  const HomeOverviewEntity({
    required this.client,
    required this.currency,
    required this.kpis,
    required this.renewalAlerts,
    required this.policies,
    required this.claims,
    required this.support,
  });

  @override
  List<Object?> get props => [
        client,
        currency,
        kpis,
        renewalAlerts,
        policies,
        claims,
        support,
      ];
}
