import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/support_bloc.dart';
import '../bloc/support_event.dart';
import '../bloc/support_state.dart';
import '../../domain/entities/support_ticket_entity.dart';

class SupportPage extends StatefulWidget {
  final String token;

  const SupportPage({
    super.key,
    required this.token,
  });

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  void _fetchTickets() {
    context.read<SupportBloc>().add(FetchSupportTicketsEvent(token: widget.token));
  }

  void _showOpenTicketDialog(BuildContext context) {
    final subjectController = TextEditingController(text: 'Update my registered mobile number');
    final messageController = TextEditingController(text: 'Please change it to 98460 12345.');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.support_agent, color: Colors.purple),
              SizedBox(width: 8),
              Text('Open Support Ticket'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: messageController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Message / Issue Detail',
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
                  final subject = subjectController.text.trim();
                  final message = messageController.text.trim();

                  Navigator.pop(dialogContext);
                  context.read<SupportBloc>().add(
                        OpenSupportTicketEvent(
                          token: widget.token,
                          subject: subject,
                          message: message,
                        ),
                      );
                }
              },
              child: const Text('Submit Ticket'),
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
          'Support Tickets',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () => _showOpenTicketDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Open Ticket', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: BlocListener<SupportBloc, SupportState>(
        listener: (context, state) {
          if (state is SupportTicketCreatedSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green.shade800,
              ),
            );
            _fetchTickets();
          } else if (state is SupportErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade800,
              ),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async => _fetchTickets(),
          child: BlocBuilder<SupportBloc, SupportState>(
            buildWhen: (prev, curr) =>
                curr is SupportLoadingState ||
                curr is SupportTicketsLoadedState ||
                curr is SupportErrorState,
            builder: (context, state) {
              if (state is SupportLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SupportErrorState) {
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
                          onPressed: _fetchTickets,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is SupportTicketsLoadedState) {
                final tickets = state.tickets;

                if (tickets.isEmpty) {
                  return _buildEmptyState(context, primaryColor);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return _buildTicketCard(context, ticket, primaryColor);
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
                  color: Colors.purple.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.support_agent_outlined, size: 64, color: Colors.purple),
              ),
              const SizedBox(height: 20),
              const Text(
                'No Support Tickets Found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Have a question or request? Open a support ticket to get help from your insurance broker.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _showOpenTicketDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Open Support Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, SupportTicketEntity ticket, Color primaryColor) {
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
                Expanded(
                  child: Text(
                    ticket.subject,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ticket.status,
                    style: TextStyle(color: Colors.purple.shade900, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Text(ticket.message, style: const TextStyle(fontSize: 13)),
            if (ticket.id.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Ticket ID: ${ticket.id}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
