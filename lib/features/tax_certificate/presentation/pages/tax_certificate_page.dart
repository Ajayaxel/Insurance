import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tax_certificate_bloc.dart';
import '../bloc/tax_certificate_event.dart';
import '../bloc/tax_certificate_state.dart';
import '../../domain/entities/tax_certificate_entity.dart';

class TaxCertificatePage extends StatefulWidget {
  final String token;
  final String? initialFinancialYear;

  const TaxCertificatePage({
    super.key,
    required this.token,
    this.initialFinancialYear,
  });

  @override
  State<TaxCertificatePage> createState() => _TaxCertificatePageState();
}

class _TaxCertificatePageState extends State<TaxCertificatePage> {
  late String _selectedFy;
  final List<String> _financialYears = ['2026-27', '2025-26', '2024-25'];

  @override
  void initState() {
    super.initState();
    _selectedFy = widget.initialFinancialYear ?? '2026-27';
    _fetchCertificate();
  }

  void _fetchCertificate() {
    context.read<TaxCertificateBloc>().add(
          FetchTaxCertificateEvent(
            token: widget.token,
            financialYear: _selectedFy,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tax Exemption Certificate (80D)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchCertificate(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner & Financial Year Selector
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, const Color(0xFF263B96)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.verified_outlined, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'SECTION 80D',
                                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        // Dropdown for Financial Year
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedFy,
                              dropdownColor: Colors.white,
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              items: _financialYears.map((fy) {
                                return DropdownMenuItem<String>(
                                  value: fy,
                                  child: Text('FY $fy'),
                                );
                              }).toList(),
                              onChanged: (newFy) {
                                if (newFy != null && newFy != _selectedFy) {
                                  setState(() {
                                    _selectedFy = newFy;
                                  });
                                  _fetchCertificate();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Income Tax Statement',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '80D certificate breakdown for tax deduction claims',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // BLoC State Consumer
              BlocBuilder<TaxCertificateBloc, TaxCertificateState>(
                builder: (context, state) {
                  if (state is TaxCertificateLoadingState) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60.0),
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Fetching Tax Certificate Data...',
                              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is TaxCertificateErrorState) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _fetchCertificate,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is TaxCertificateLoadedState) {
                    final cert = state.certificate;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Totals Summary Card
                        _buildTotalsCard(context, cert.totals, cert.broker.currency),
                        const SizedBox(height: 20),

                        // Insured & Broker Details
                        Row(
                          children: [
                            Expanded(child: _buildInsuredCard(cert.insured)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildBrokerCard(cert.broker)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Section lines
                        Text(
                          'Policy Tax Deduction Breakdown',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),
                        const SizedBox(height: 10),

                        if (cert.lines.isEmpty)
                          _buildEmptyLinesCard(context)
                        else
                          ...cert.lines.map((line) => _buildTaxLineTile(context, line, cert.broker.currency)),

                        const SizedBox(height: 24),

                        // Action Button: Download / Print PDF
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Downloading 80D Tax Certificate for FY $_selectedFy...'),
                                  backgroundColor: primaryColor,
                                ),
                              );
                            },
                            icon: const Icon(Icons.picture_as_pdf_outlined),
                            label: const Text(
                              'Download Tax Certificate (PDF)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalsCard(BuildContext context, TotalsEntity totals, String currency) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tax Eligible Premium Summary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    currency,
                    style: TextStyle(color: Colors.teal.shade800, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildTotalStat(
                    label: 'Total Premium',
                    amount: totals.premiumInr,
                    color: const Color(0xFF122376),
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                Expanded(
                  child: _buildTotalStat(
                    label: 'Health (80D)',
                    amount: totals.healthPremiumInr,
                    color: Colors.teal.shade700,
                    icon: Icons.medical_services_outlined,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                Expanded(
                  child: _buildTotalStat(
                    label: 'Life (80C)',
                    amount: totals.lifePremiumInr,
                    color: Colors.indigo.shade700,
                    icon: Icons.favorite_border_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalStat({
    required String label,
    required num amount,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          '₹ ${amount.toStringAsFixed(0)}',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildInsuredCard(InsuredEntity insured) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, size: 18, color: Colors.blue.shade700),
                const SizedBox(width: 6),
                const Text('Insured', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              insured.name.isNotEmpty ? insured.name : 'Insured Policyholder',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              insured.email.isNotEmpty ? insured.email : 'N/A',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
            if (insured.phone.isNotEmpty)
              Text(
                insured.phone,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrokerCard(BrokerEntity broker) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business_outlined, size: 18, color: Colors.purple.shade700),
                const SizedBox(width: 6),
                const Text('Broker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              broker.name.isNotEmpty ? broker.name : 'Insurance Broker',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              '${broker.country} · ${broker.currency}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyLinesCard(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.receipt_outlined, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 8),
              const Text(
                'No tax eligible policy transactions found',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                'Premium paid records for FY $_selectedFy will appear here once issued.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaxLineTile(BuildContext context, TaxLineEntity line, String currency) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            line.policyType == 'HEALTH' ? Icons.health_and_safety_outlined : Icons.shield_outlined,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          line.policyNumber.isNotEmpty ? line.policyNumber : 'Policy Premium',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          '${line.policyType} · Section ${line.taxDeductionSection}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        trailing: Text(
          '₹ ${line.premiumAmountInr.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
