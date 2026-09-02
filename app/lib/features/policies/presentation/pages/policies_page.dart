import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/policy_bloc.dart';
import '../bloc/policy_event.dart';
import '../bloc/policy_state.dart';
import '../../domain/entities/policy_document_entity.dart';
import '../../domain/entities/policy_entity.dart';

class PoliciesPage extends StatefulWidget {
  final String token;

  const PoliciesPage({
    super.key,
    required this.token,
  });

  @override
  State<PoliciesPage> createState() => _PoliciesPageState();
}

class _PoliciesPageState extends State<PoliciesPage> {
  @override
  void initState() {
    super.initState();
    _fetchPolicies();
  }

  void _fetchPolicies() {
    context.read<PolicyBloc>().add(FetchPoliciesEvent(token: widget.token));
  }

  void _showDocumentsBottomSheet(BuildContext context, String policyId, List<PolicyDocumentEntity> documents) {
    final primaryColor = Theme.of(context).primaryColor;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.folder_open, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Policy Documents & Attachments',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
              Text(
                'Policy ID: $policyId',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              const Divider(height: 24),
              if (documents.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.insert_drive_file_outlined, size: 40, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        const Text(
                          'No document attachments found for this policy.',
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final doc = documents[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          child: Icon(Icons.picture_as_pdf, color: primaryColor, size: 20),
                        ),
                        title: Text(
                          doc.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: doc.type != null
                            ? Text(doc.type!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12))
                            : null,
                        trailing: IconButton(
                          icon: Icon(Icons.download, color: primaryColor),
                          onPressed: () {
                            Navigator.pop(sheetContext);
                            context.read<PolicyBloc>().add(
                                  DownloadPolicyDocumentEvent(
                                    token: widget.token,
                                    policyId: policyId,
                                  ),
                                );
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
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
          'My Insurance Policies',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: BlocListener<PolicyBloc, PolicyState>(
        listener: (context, state) {
          if (state is PolicyDocumentDownloadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Downloading policy document PDF for #${state.policyId}...'),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is PolicyDocumentDownloadedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Downloaded ${state.documentBytes.length} bytes for policy document #${state.policyId}.'),
                backgroundColor: Colors.green.shade800,
                duration: const Duration(seconds: 4),
              ),
            );
          } else if (state is PolicyDocumentsListLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Fetching documents list for policy #${state.policyId}...'),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is PolicyDocumentsListLoadedState) {
            _showDocumentsBottomSheet(context, state.policyId, state.documents);
          }
        },
        child: RefreshIndicator(
          onRefresh: () async => _fetchPolicies(),
          child: BlocBuilder<PolicyBloc, PolicyState>(
            buildWhen: (previous, current) =>
                current is PolicyLoadingState ||
                current is PolicyLoadedState ||
                current is PolicyErrorState,
            builder: (context, state) {
              if (state is PolicyLoadingState) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Loading your policies...',
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }

              if (state is PolicyErrorState) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          onPressed: _fetchPolicies,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is PolicyLoadedState) {
                final policies = state.policies;

                if (policies.isEmpty) {
                  return _buildEmptyState(context, primaryColor);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: policies.length,
                  itemBuilder: (context, index) {
                    final policy = policies[index];
                    return _buildPolicyCard(context, policy, primaryColor);
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
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: 64,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No Active Policies Found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'There are currently no active or historical insurance policies registered for your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _fetchPolicies,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh List'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard(BuildContext context, PolicyEntity policy, Color primaryColor) {
    final String targetPolicyId = policy.id.isNotEmpty ? policy.id : policy.policyNumber;

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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getPolicyIcon(policy.type),
                        color: primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          policy.planName ?? policy.type,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Policy #: ${policy.policyNumber}',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: policy.isActive ? Colors.green.shade100 : Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    policy.status,
                    style: TextStyle(
                      color: policy.isActive ? Colors.green.shade800 : Colors.amber.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (policy.insuredAmountInr != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Insured Value', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(
                        '₹ ${policy.insuredAmountInr!.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                if (policy.premiumAmountInr != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Premium Amount', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(
                        '₹ ${policy.premiumAmountInr!.toStringAsFixed(0)}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryColor),
                      ),
                    ],
                  ),
                if (policy.endDate != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Valid Until', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(
                        policy.endDate!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      context.read<PolicyBloc>().add(
                            DownloadPolicyDocumentEvent(
                              token: widget.token,
                              policyId: targetPolicyId,
                            ),
                          );
                    },
                    icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                    label: const Text(
                      'PDF Document',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      context.read<PolicyBloc>().add(
                            FetchPolicyDocumentsListEvent(
                              token: widget.token,
                              policyId: targetPolicyId,
                            ),
                          );
                    },
                    icon: const Icon(Icons.folder_open_outlined, size: 16),
                    label: const Text(
                      'All Documents',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPolicyIcon(String type) {
    switch (type.toUpperCase()) {
      case 'HEALTH':
        return Icons.health_and_safety_outlined;
      case 'MOTOR':
        return Icons.directions_car_outlined;
      case 'LIFE':
        return Icons.favorite_border_outlined;
      default:
        return Icons.shield_outlined;
    }
  }
}
