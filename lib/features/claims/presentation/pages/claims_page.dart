import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/claim_bloc.dart';
import '../bloc/claim_event.dart';
import '../bloc/claim_state.dart';
import '../../domain/entities/claim_entity.dart';

class ClaimsPage extends StatefulWidget {
  final String token;

  const ClaimsPage({
    super.key,
    required this.token,
  });

  @override
  State<ClaimsPage> createState() => _ClaimsPageState();
}

class _ClaimsPageState extends State<ClaimsPage> {
  @override
  void initState() {
    super.initState();
    _fetchClaims();
  }

  void _fetchClaims() {
    context.read<ClaimBloc>().add(FetchClaimsEvent(token: widget.token));
  }

  void _showRaiseClaimDialog(BuildContext context) {
    final policyIdController = TextEditingController();
    final dateController = TextEditingController(text: '2026-08-01');
    final descController = TextEditingController(
      text: 'Rear-ended at a signal; bumper and tail lamp damaged.',
    );
    final amountController = TextEditingController(text: '45000');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.assignment_late_outlined, color: Colors.orange),
              SizedBox(width: 8),
              Text('Raise a New Claim'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: policyIdController,
                    decoration: const InputDecoration(
                      labelText: 'Policy ID / Number',
                      hintText: 'e.g. pol_123',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Incident Date (YYYY-MM-DD)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Estimated Amount (INR)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || num.tryParse(v) == null ? 'Enter valid number' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Incident Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final policyId = policyIdController.text.trim();
                  final date = dateController.text.trim();
                  final desc = descController.text.trim();
                  final amount = num.parse(amountController.text.trim());

                  Navigator.pop(dialogContext);
                  context.read<ClaimBloc>().add(
                        RaiseClaimEvent(
                          token: widget.token,
                          policyId: policyId,
                          incidentDate: date,
                          description: desc,
                          estimatedAmountInr: amount,
                        ),
                      );
                }
              },
              child: const Text('Submit Claim'),
            ),
          ],
        );
      },
    );
  }

  void _showAttachDocsDialog(BuildContext context, String claimId) {
    final keyController = TextEditingController(text: 'fir_copy');
    final urlController = TextEditingController(text: 'https://example.com/fir.pdf');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.attach_file_outlined, color: Colors.blue),
              SizedBox(width: 8),
              Text('Attach Document'),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: keyController,
                  decoration: const InputDecoration(
                    labelText: 'Document Key / Label',
                    hintText: 'e.g. fir_copy, repair_estimate',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'Document URL',
                    hintText: 'https://...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final key = keyController.text.trim();
                  final url = urlController.text.trim();

                  Navigator.pop(dialogContext);
                  context.read<ClaimBloc>().add(
                        AttachClaimDocsEvent(
                          token: widget.token,
                          claimId: claimId,
                          documents: [
                            ClaimDocumentEntity(key: key, url: url),
                          ],
                        ),
                      );
                }
              },
              child: const Text('Attach Doc'),
            ),
          ],
        );
      },
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
          'My Claims',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () => _showRaiseClaimDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Raise Claim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: BlocListener<ClaimBloc, ClaimState>(
        listener: (context, state) {
          if (state is ClaimSubmittedSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green.shade800,
              ),
            );
            _fetchClaims();
          } else if (state is ClaimErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade800,
              ),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async => _fetchClaims(),
          child: BlocBuilder<ClaimBloc, ClaimState>(
            buildWhen: (prev, curr) =>
                curr is ClaimLoadingState ||
                curr is ClaimsLoadedState ||
                curr is ClaimErrorState,
            builder: (context, state) {
              if (state is ClaimLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ClaimErrorState) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 12),
                        Text(state.message, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _fetchClaims,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is ClaimsLoadedState) {
                final claims = state.claims;

                if (claims.isEmpty) {
                  return _buildEmptyState(context, primaryColor);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: claims.length,
                  itemBuilder: (context, index) {
                    final claim = claims[index];
                    return _buildClaimCard(context, claim, primaryColor);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color primaryColor) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.assignment_late_outlined, size: 64, color: Colors.orange),
              ),
              const SizedBox(height: 20),
              const Text(
                'No Claims Filed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'You have not submitted any insurance claims yet.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _showRaiseClaimDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Raise a Claim'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClaimCard(BuildContext context, ClaimEntity claim, Color primaryColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Claim #${claim.id.isNotEmpty ? claim.id : 'N/A'}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    claim.status,
                    style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(claim.description, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date: ${claim.incidentDate}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                Text(
                  'Est: ₹ ${claim.estimatedAmountInr}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 13),
                ),
              ],
            ),
            if (claim.documents.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Attached Documents:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: claim.documents.map((doc) {
                  return Chip(
                    avatar: const Icon(Icons.insert_drive_file, size: 14),
                    label: Text(doc.key, style: const TextStyle(fontSize: 11)),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showAttachDocsDialog(context, claim.id),
                icon: const Icon(Icons.attach_file, size: 16),
                label: const Text('Attach Documents'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
