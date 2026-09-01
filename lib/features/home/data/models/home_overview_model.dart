import '../../domain/entities/home_overview_entity.dart';

class ClientModel extends ClientEntity {
  const ClientModel({
    required super.name,
    required super.email,
    required super.phone,
    required super.type,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      type: (json['type'] ?? 'INDIVIDUAL').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'type': type,
    };
  }
}

class KpisModel extends KpisEntity {
  const KpisModel({
    required super.activePolicies,
    required super.totalSumInsuredInr,
    required super.annualPremiumInr,
    required super.openClaims,
  });

  factory KpisModel.fromJson(Map<String, dynamic> json) {
    return KpisModel(
      activePolicies: (json['activePolicies'] ?? 0) as num,
      totalSumInsuredInr: (json['totalSumInsuredInr'] ?? 0) as num,
      annualPremiumInr: (json['annualPremiumInr'] ?? 0) as num,
      openClaims: (json['openClaims'] ?? 0) as num,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activePolicies': activePolicies,
      'totalSumInsuredInr': totalSumInsuredInr,
      'annualPremiumInr': annualPremiumInr,
      'openClaims': openClaims,
    };
  }
}

class HomeOverviewModel extends HomeOverviewEntity {
  const HomeOverviewModel({
    required super.client,
    required super.currency,
    required super.kpis,
    required super.renewalAlerts,
    required super.policies,
    required super.claims,
    required super.support,
  });

  factory HomeOverviewModel.fromJson(Map<String, dynamic> json) {
    final clientMap = json['client'] as Map<String, dynamic>? ?? {};
    final kpisMap = json['kpis'] as Map<String, dynamic>? ?? {};

    return HomeOverviewModel(
      client: ClientModel.fromJson(clientMap),
      currency: (json['currency'] ?? 'INR').toString(),
      kpis: KpisModel.fromJson(kpisMap),
      renewalAlerts: (json['renewalAlerts'] as List<dynamic>?) ?? [],
      policies: (json['policies'] as List<dynamic>?) ?? [],
      claims: (json['claims'] as List<dynamic>?) ?? [],
      support: (json['support'] as List<dynamic>?) ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client': (client as ClientModel).toJson(),
      'currency': currency,
      'kpis': (kpis as KpisModel).toJson(),
      'renewalAlerts': renewalAlerts,
      'policies': policies,
      'claims': claims,
      'support': support,
    };
  }
}
