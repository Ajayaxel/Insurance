import 'package:equatable/equatable.dart';

class BrokerEntity extends Equatable {
  final String name;
  final String country;
  final String currency;

  const BrokerEntity({
    required this.name,
    required this.country,
    required this.currency,
  });

  @override
  List<Object?> get props => [name, country, currency];
}

class InsuredEntity extends Equatable {
  final String name;
  final String email;
  final String phone;

  const InsuredEntity({
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [name, email, phone];
}

class PeriodEntity extends Equatable {
  final String from;
  final String to;

  const PeriodEntity({
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [from, to];
}

class TaxLineEntity extends Equatable {
  final String policyNumber;
  final String policyType;
  final num premiumAmountInr;
  final String taxDeductionSection;

  const TaxLineEntity({
    required this.policyNumber,
    required this.policyType,
    required this.premiumAmountInr,
    required this.taxDeductionSection,
  });

  @override
  List<Object?> get props => [
        policyNumber,
        policyType,
        premiumAmountInr,
        taxDeductionSection,
      ];
}

class TotalsEntity extends Equatable {
  final num premiumInr;
  final num healthPremiumInr;
  final num lifePremiumInr;

  const TotalsEntity({
    required this.premiumInr,
    required this.healthPremiumInr,
    required this.lifePremiumInr,
  });

  @override
  List<Object?> get props => [premiumInr, healthPremiumInr, lifePremiumInr];
}

class TaxCertificateEntity extends Equatable {
  final BrokerEntity broker;
  final InsuredEntity insured;
  final String financialYear;
  final PeriodEntity period;
  final List<TaxLineEntity> lines;
  final TotalsEntity totals;
  final String generatedAt;

  const TaxCertificateEntity({
    required this.broker,
    required this.insured,
    required this.financialYear,
    required this.period,
    required this.lines,
    required this.totals,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [
        broker,
        insured,
        financialYear,
        period,
        lines,
        totals,
        generatedAt,
      ];
}
