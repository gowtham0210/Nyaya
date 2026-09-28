import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/show_message.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import '../../../core/presentation/widgets/detail_scaffold.dart';
import 'support_validation.dart';
import 'support_view_model.dart';

/// Help & Support (spec 031): send a request to the team and see past ones.
class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key, required this.viewModel});

  final SupportViewModel viewModel;

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _message = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final sentMessage = context.l10n.supportSent;
    final sent = await widget.viewModel.send(
      subject: _subject.text,
      message: _message.text,
    );
    if (sent && mounted) {
      _formKey.currentState!.reset();
      _subject.clear();
      _message.clear();
      showMessage(context, sentMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final viewModel = widget.viewModel;
        final error = viewModel.sendError;
        return DetailScaffold(
          title: l10n.profileHelpSupport,
          children: [
            DetailHeading(l10n.supportContactTitle),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    key: const ValueKey('support.subject'),
                    controller: _subject,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: l10n.supportSubject),
                    validator: (value) => validateSupportSubject(l10n, value),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const ValueKey('support.message'),
                    controller: _message,
                    minLines: 3,
                    maxLines: 6,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: l10n.supportMessage,
                      alignLabelWithHint: true,
                    ),
                    validator: (value) => validateSupportMessage(l10n, value),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      failureMessage(l10n, error),
                      style: const TextStyle(color: brandDanger, height: 1.4),
                    ),
                  ],
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    key: const ValueKey('support.send'),
                    onPressed: viewModel.sending ? null : _send,
                    icon: viewModel.sending
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded, size: 18),
                    label: Text(l10n.supportSend),
                    style: FilledButton.styleFrom(
                      backgroundColor: brandNavy,
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                ],
              ),
            ),
            DetailHeading(l10n.supportRequestsTitle),
            LoadStateView<List<SupportRequest>>(
              state: viewModel.state,
              onRetry: viewModel.load,
              emptyMessage: l10n.supportRequestsEmpty,
              emptyIcon: Icons.mark_email_read_outlined,
              builder: (context, requests) => Column(
                children: [
                  for (final request in requests) ...[
                    _RequestCard(request: request),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});

  final SupportRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, color) = switch (request.status) {
      SupportStatus.open => (l10n.supportStatusOpen, brandGold),
      SupportStatus.inProgress => (
        l10n.supportStatusInProgress,
        const Color(0xFF2F6FED),
      ),
      SupportStatus.resolved => (
        l10n.supportStatusResolved,
        const Color(0xFF1FA35B),
      ),
      SupportStatus.closed => (l10n.supportStatusClosed, brandSupportText),
    };
    final locale = Localizations.localeOf(context).toLanguageTag();
    return MergeSemantics(
      child: DetailCard(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        request.subject,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: brandNavy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  request.message,
                  style: const TextStyle(height: 1.4, color: brandSupportText),
                ),
                if (request.createdAt case final createdAt?) ...[
                  const SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd(locale).format(createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: brandSupportText,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
