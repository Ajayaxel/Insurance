import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/declaration_bloc.dart';
import '../bloc/declaration_event.dart';
import '../bloc/declaration_state.dart';
import '../../domain/entities/declaration_entity.dart';

class DeclarationsPage extends StatefulWidget {
  final String token;

  const DeclarationsPage({
    super.key,
    required this.token,
  });

  @override
  State<DeclarationsPage> createState() => _DeclarationsPageState();
}

class _DeclarationsPageState extends State<DeclarationsPage> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _fetchDeclarations();
  }

  void _fetchDeclarations() {
    context.read<DeclarationBloc>().add(FetchDeclarationsEvent(token: widget.token));
  }

  void _showCategorySelectionDialog(BuildContext context) {
    String selectedCategory = 'health';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF142468).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.add_task_rounded, color: Color(0xFF142468), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'New Declaration Form',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF142468)),
                          ),
                          Text(
                            'Select declaration type to load backend schema',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Option 1: Health Declaration
                  InkWell(
                    onTap: () => setSheetState(() => selectedCategory = 'health'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selectedCategory == 'health' ? const Color(0xFF142468).withValues(alpha: 0.04) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selectedCategory == 'health' ? const Color(0xFF142468) : const Color(0xFFE2E8F0),
                          width: selectedCategory == 'health' ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.health_and_safety_rounded, color: Colors.teal.shade800, size: 24),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Health Declaration',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF142468)),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Medical history, lifestyle, and condition form',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Radio<String>(
                            value: 'health',
                            groupValue: selectedCategory,
                            activeColor: const Color(0xFF142468),
                            onChanged: (val) {
                              if (val != null) setSheetState(() => selectedCategory = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Option 2: Motor Declaration
                  InkWell(
                    onTap: () => setSheetState(() => selectedCategory = 'motor'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selectedCategory == 'motor' ? const Color(0xFF142468).withValues(alpha: 0.04) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selectedCategory == 'motor' ? const Color(0xFF142468) : const Color(0xFFE2E8F0),
                          width: selectedCategory == 'motor' ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.directions_car_rounded, color: Colors.amber.shade900, size: 24),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Motor Declaration',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF142468)),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Vehicle modifications, usage, and claims history',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Radio<String>(
                            value: 'motor',
                            groupValue: selectedCategory,
                            activeColor: const Color(0xFF142468),
                            onChanged: (val) {
                              if (val != null) setSheetState(() => selectedCategory = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF142468),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _showDeclarationFormModal(context, selectedCategory);
                      },
                      icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                      label: const Text('Continue to Questionnaire', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDeclarationFormModal(BuildContext context, String category) {
    bool tobaccoAnswer = false;
    bool existingConditionsAnswer = false;
    final declarationIdController = TextEditingController(
      text: 'decl_${DateTime.now().millisecondsSinceEpoch}',
    );

    context.read<DeclarationBloc>().add(
          FetchDeclarationFormEvent(token: widget.token, category: category),
        );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF142468).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                category == 'motor' ? Icons.directions_car : Icons.health_and_safety,
                                color: const Color(0xFF142468),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${category.toUpperCase()} Questionnaire',
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF142468)),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    TextFormField(
                      controller: declarationIdController,
                      decoration: InputDecoration(
                        labelText: 'Declaration Reference ID',
                        prefixIcon: const Icon(Icons.tag_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.bolt_rounded, color: Color(0xFF2563EB), size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Dynamic schema active. Answers auto-save in real-time as customer types/toggles.',
                              style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF), fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            activeColor: const Color(0xFF142468),
                            title: const Text('Tobacco / Smoking History', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            subtitle: const Text('Consumed tobacco products in last 24 months?', style: TextStyle(fontSize: 12)),
                            value: tobaccoAnswer,
                            onChanged: (val) {
                              setSheetState(() => tobaccoAnswer = val);
                              context.read<DeclarationBloc>().add(
                                    SaveDeclarationDraftEvent(
                                      token: widget.token,
                                      declarationId: declarationIdController.text.trim(),
                                      answers: {
                                        'tobacco': tobaccoAnswer,
                                        'existingConditions': existingConditionsAnswer,
                                      },
                                    ),
                                  );
                            },
                          ),
                          const Divider(height: 1),
                          SwitchListTile(
                            activeColor: const Color(0xFF142468),
                            title: const Text('Pre-existing Medical Conditions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            subtitle: const Text('Any chronic illness or surgical history to declare?', style: TextStyle(fontSize: 12)),
                            value: existingConditionsAnswer,
                            onChanged: (val) {
                              setSheetState(() => existingConditionsAnswer = val);
                              context.read<DeclarationBloc>().add(
                                    SaveDeclarationDraftEvent(
                                      token: widget.token,
                                      declarationId: declarationIdController.text.trim(),
                                      answers: {
                                        'tobacco': tobaccoAnswer,
                                        'existingConditions': existingConditionsAnswer,
                                      },
                                    ),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF142468)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                context.read<DeclarationBloc>().add(
                                      SaveDeclarationDraftEvent(
                                        token: widget.token,
                                        declarationId: declarationIdController.text.trim(),
                                        answers: {
                                          'tobacco': tobaccoAnswer,
                                          'existingConditions': existingConditionsAnswer,
                                        },
                                      ),
                                    );
                              },
                              icon: const Icon(Icons.bookmark_border_rounded, size: 18),
                              label: const Text('Save Draft', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF142468),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.pop(sheetContext);
                                context.read<DeclarationBloc>().add(
                                      SubmitDeclarationEvent(
                                        token: widget.token,
                                        declarationId: declarationIdController.text.trim(),
                                        answers: {
                                          'tobacco': tobaccoAnswer,
                                          'existingConditions': existingConditionsAnswer,
                                        },
                                      ),
                                    );
                              },
                              icon: const Icon(Icons.send_rounded, size: 18),
                              label: const Text('Submit', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showPrintPdfDialog(BuildContext context, String pdfUrl) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 10),
            const Text('Signed PDF Statement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: SelectableText(
            pdfUrl,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF142468),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF142468);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Policy Declarations',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Refresh List',
            onPressed: _fetchDeclarations,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        elevation: 4,
        onPressed: () => _showCategorySelectionDialog(context),
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: const Text(
          'Fill Declaration',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<DeclarationBloc, DeclarationState>(
        listener: (context, state) {
          if (state is DeclarationSavedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Draft saved in real-time'),
                backgroundColor: Colors.blue,
                duration: Duration(seconds: 1),
              ),
            );
          } else if (state is DeclarationSubmittedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Declaration submitted & signed successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            _fetchDeclarations();
          } else if (state is DeclarationRevisedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('New revision created (ID: ${state.newRevision.id})'),
                backgroundColor: Colors.orange.shade800,
              ),
            );
            _fetchDeclarations();
          } else if (state is DeclarationPrintedState) {
            _showPrintPdfDialog(context, state.pdfUrl);
          } else if (state is DeclarationErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade800,
              ),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async => _fetchDeclarations(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Navy Header Banner Card (matching screenshot top banner)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF142468), Color(0xFF1E3A8A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF142468).withValues(alpha: 0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
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
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.verified_rounded, size: 12, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'INSURANCE DECLARATIONS',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'FY 2026-27',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Policyholder Statements',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Dynamic risk questionnaires, draft answers, & signed PDF downloads',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // BLoC State & Declarations Summary Card (matching screenshot summary card layout)
                BlocBuilder<DeclarationBloc, DeclarationState>(
                  buildWhen: (prev, curr) =>
                      curr is DeclarationLoadingState ||
                      curr is DeclarationsLoadedState ||
                      curr is DeclarationErrorState,
                  builder: (context, state) {
                    if (state is DeclarationsLoadedState) {
                      final declarations = state.declarations;
                      final totalCount = declarations.length;
                      final draftCount = declarations.where((d) => d.status.toUpperCase() == 'DRAFT').length;
                      final submittedCount = declarations.where((d) => d.status.toUpperCase() == 'SUBMITTED').length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // White Summary Card (exact style of Tax Eligible Premium Summary card in screenshot)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(color: const Color(0xFFEAEFF5)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Declarations Summary',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF142468),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFECFDF5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'ACTIVE',
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF047857)),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Divider(height: 1),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSummaryMetric(
                                        context,
                                        icon: Icons.assignment_outlined,
                                        title: 'Total',
                                        value: totalCount.toString(),
                                        color: const Color(0xFF142468),
                                      ),
                                    ),
                                    Container(width: 1, height: 36, color: Colors.grey.shade200),
                                    Expanded(
                                      child: _buildSummaryMetric(
                                        context,
                                        icon: Icons.edit_note_rounded,
                                        title: 'Drafts',
                                        value: draftCount.toString(),
                                        color: Colors.amber.shade900,
                                      ),
                                    ),
                                    Container(width: 1, height: 36, color: Colors.grey.shade200),
                                    Expanded(
                                      child: _buildSummaryMetric(
                                        context,
                                        icon: Icons.verified_user_outlined,
                                        title: 'Signed',
                                        value: submittedCount.toString(),
                                        color: Colors.green.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Filter Pill Selector Bar
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Health', 'Motor', 'Draft', 'Submitted'].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          selected: isSelected,
                          label: Text(filter),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                          backgroundColor: Colors.white,
                          selectedColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
                            ),
                          ),
                          onSelected: (val) {
                            setState(() => _selectedFilter = filter);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Section Title
                const Text(
                  'Policy Declarations List',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF142468),
                  ),
                ),
                const SizedBox(height: 10),

                // BLoC Content List
                BlocBuilder<DeclarationBloc, DeclarationState>(
                  buildWhen: (prev, curr) =>
                      curr is DeclarationLoadingState ||
                      curr is DeclarationsLoadedState ||
                      curr is DeclarationErrorState,
                  builder: (context, state) {
                    if (state is DeclarationLoadingState) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (state is DeclarationErrorState) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 40),
                            const SizedBox(height: 10),
                            Text(state.message, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                              onPressed: _fetchDeclarations,
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Try Again'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is DeclarationsLoadedState) {
                      final filteredList = state.declarations.where((d) {
                        if (_selectedFilter == 'Health') return d.category.toLowerCase() == 'health';
                        if (_selectedFilter == 'Motor') return d.category.toLowerCase() == 'motor';
                        if (_selectedFilter == 'Draft') return d.status.toUpperCase() == 'DRAFT';
                        if (_selectedFilter == 'Submitted') return d.status.toUpperCase() == 'SUBMITTED';
                        return true;
                      }).toList();

                      if (filteredList.isEmpty) {
                        return _buildEmptyState(context, primaryColor);
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final declaration = filteredList[index];
                          return _buildDeclarationCard(context, declaration, primaryColor);
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryMetric(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assignment_turned_in_outlined, size: 56, color: primaryColor),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Declarations Found',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF142468)),
          ),
          const SizedBox(height: 6),
          Text(
            'No declaration records matching filter "$_selectedFilter". Complete a dynamic questionnaire for health or motor coverage.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => _showCategorySelectionDialog(context),
            icon: const Icon(Icons.add_task_rounded, size: 18),
            label: const Text('Fill New Declaration', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDeclarationCard(
    BuildContext context,
    DeclarationEntity declaration,
    Color primaryColor,
  ) {
    final isSubmitted = declaration.status.toUpperCase() == 'SUBMITTED';
    final isMotor = declaration.category.toLowerCase() == 'motor';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar of Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMotor ? Colors.amber.shade50 : Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isMotor ? Icons.directions_car_rounded : Icons.health_and_safety_rounded,
                        color: isMotor ? Colors.amber.shade900 : Colors.teal.shade800,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${declaration.category.toUpperCase()} DECLARATION',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: #${declaration.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF142468)),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSubmitted ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isSubmitted ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSubmitted ? Icons.check_circle_rounded : Icons.edit_note_rounded,
                        size: 14,
                        color: isSubmitted ? const Color(0xFF047857) : const Color(0xFFB45309),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        declaration.status,
                        style: TextStyle(
                          color: isSubmitted ? const Color(0xFF047857) : const Color(0xFFB45309),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1),
            ),

            // Two Side-By-Side Detail Pill Cards (matching Insured & Broker cards in screenshot)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.category_outlined, size: 14, color: Color(0xFF64748B)),
                            SizedBox(width: 4),
                            Text('Category', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          declaration.category.toUpperCase(),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF142468)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shield_outlined, size: 14, color: Color(0xFF64748B)),
                            SizedBox(width: 4),
                            Text('Revision', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isSubmitted ? 'Signed Version' : 'Draft Copy',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF142468)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Question Answers Summary Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Response Summary:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: declaration.answers.entries.map((entry) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Full-Width / Action Buttons (matching bottom download button styling in screenshot)
            if (isSubmitted) ...[
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF142468)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          context.read<DeclarationBloc>().add(
                                ReviseDeclarationEvent(
                                  token: widget.token,
                                  declarationId: declaration.id,
                                ),
                              );
                        },
                        icon: const Icon(Icons.edit_note_rounded, size: 18),
                        label: const Text('Revise', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF142468),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          context.read<DeclarationBloc>().add(
                                PrintDeclarationEvent(
                                  token: widget.token,
                                  declarationId: declaration.id,
                                ),
                              );
                        },
                        icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                        label: const Text('Download PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _showDeclarationFormModal(context, declaration.category),
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Text('Edit Draft Questionnaire', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
