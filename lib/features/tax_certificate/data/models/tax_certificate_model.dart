import '../../domain/entities/tax_certificate_entity.dart';

class BrokerModel extends BrokerEntity {
  const BrokerModel({
    required super.name,
    required super.country,
    required super.currency,
  });

  factory BrokerModel.fromJson(Map<String, dynamic> json) {
    return BrokerModel(
      name: (json['name'] ?? '').toString(),
      country: (json['country'] ?? 'IN').toString(),
      currency: (json['currency'] ?? 'INR').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'currency': currency,
    };
  }
}

class InsuredModel extends InsuredEntity {
  const InsuredModel({
    required super.name,
    required super.email,
    required super.phone,
  });

  factory InsuredModel.fromJson(Map<String, dynamic> json) {
    return InsuredModel(
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}

class PeriodModel extends PeriodEntity {
  const PeriodModel({
    required super.from,
    required super.to,
  });

  factory PeriodModel.fromJson(Map<String, dynamic> json) {
    return PeriodModel(
      from: (json['from'] ?? '').toString(),
      to: (json['to'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
    };
  }
}

class TaxLineModel extends TaxLineEntity {
  const TaxLineModel({
    required super.policyNumber,
    required super.policyType,
    required super.premiumAmountInr,
    required super.taxDeductionSection,
  });

  factory TaxLineModel.fromJson(Map<String, dynamic> json) {
    return TaxLineModel(
      policyNumber: (json['policyNumber'] ?? json['policy'] ?? '').toString(),
      policyType: (json['policyType'] ?? json['type'] ?? 'HEALTH').toString(),
      premiumAmountInr: (json['premiumAmountInr'] ?? json['amount'] ?? 0) as num,
      taxDeductionSection: (json['taxDeductionSection'] ?? json['section'] ?? '80D').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'policyNumber': policyNumber,
      'policyType': policyType,
      'premiumAmountInr': premiumAmountInr,
      'taxDeductionSection': taxDeductionSection,
    };
  }
}

class TotalsModel extends TotalsEntity {
  const TotalsModel({
    required super.premiumInr,
    required super.healthPremiumInr,
    required super.lifePremiumInr,
  });

  factory TotalsModel.fromJson(Map<String, dynamic> json) {
    return TotalsModel(
      premiumInr: (json['premiumInr'] ?? 0) as num,
      healthPremiumInr: (json['healthPremiumInr'] ?? 0) as num,
      lifePremiumInr: (json['lifePremiumInr'] ?? 0) as num,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'premiumInr': premiumInr,
      'healthPremiumInr': healthPremiumInr,
      'lifePremiumInr': lifePremiumInr,
    };
  }
}

class TaxCertificateModel extends TaxCertificateEntity {
  const TaxCertificateModel({
    required super.broker,
    required super.insured,
    required super.financialYear,
    required super.period,
    required super.lines,
    required super.totals,
    required super.generatedAt,
  });

  factory TaxCertificateModel.fromJson(Map<String, dynamic> json) {
    final brokerMap = json['broker'] as Map<String, dynamic>? ?? {};
    final insuredMap = json['insured'] as Map<String, dynamic>? ?? {};
    final periodMap = json['period'] as Map<String, dynamic>? ?? {};
    final totalsMap = json['totals'] as Map<String, dynamic>? ?? {};
    final rawLines = (json['lines'] as List<dynamic>?) ?? [];

    return TaxCertificateModel(
      broker: BrokerModel.fromJson(brokerMap),
      insured: InsuredModel.fromJson(insuredMap),
      financialYear: (json['financialYear'] ?? '').toString(),
      period: PeriodModel.fromJson(periodMap),
      lines: rawLines
          .map((line) => TaxLineModel.fromJson(line as Map<String, dynamic>))
          .toList(),
      totals: TotalsModel.fromJson(totalsMap),
      generatedAt: (json['generatedAt'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'broker': (broker as BrokerModel).toJson(),
      'insured': (insured as InsuredModel).toJson(),
      'financialYear': financialYear,
      'period': (period as PeriodModel).toJson(),
      'lines': lines.map((l) => (l as TaxLineModel).toJson()).toList(),
      'totals': (totals as TotalsModel).toJson(),
      'generatedAt': generatedAt,
    };
  }
}
