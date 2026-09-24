import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../models/support_request.dart';
import '../repositories/profile_repository.dart';
import '../services/api_exceptions.dart';
import '../theme/app_colors.dart';
import '../widgets/settings_page.dart';

/// Help & Support: FAQs about the app, plus a real contact form —
/// requests are stored by the backend (POST /users/me/support-requests)
/// and listed back to the user below.
class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _repository = ProfileRepository();
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _sending = false;
  String? _errorMessage;
  List<SupportRequest>? _requests;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadRequests() async {
    try {
      final items = await _repository.getSupportRequests();
      if (mounted) setState(() => _requests = items);
    } catch (_) {
      if (mounted) setState(() => _requests = const []);
    }
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _sending = true;
      _errorMessage = null;
    });
    try {
      await _repository.submitSupportRequest(subject: _subjectController.text.trim(), message: _messageController.text.trim());
      if (!mounted) return;
      _subjectController.clear();
      _messageController.clear();
      showSettingsSnack(context, tr('support_sent_message'));
      _loadRequests();
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } on NetworkException catch (e) {
      setState(() => _errorMessage = e.message);
    } on UnauthenticatedException {
      setState(() => _errorMessage = tr('profile_signin_message'));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final faqs = [
      (tr('faq_q1'), tr('faq_a1')),
      (tr('faq_q2'), tr('faq_a2')),
      (tr('faq_q3'), tr('faq_a3')),
      (tr('faq_q4'), tr('faq_a4')),
      (tr('faq_q5'), tr('faq_a5')),
    ];

    return SettingsPage(
      title: tr('placeholder_help_support'),
      children: [
        SettingsSectionTitle(tr('help_faq_title')),
        SettingsCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Column(
              children: [
                for (var i = 0; i < faqs.length; i++) ...[
                  ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    iconColor: AppColors.gold,
                    collapsedIconColor: AppColors.muted,
                    title: Text(faqs[i].$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    children: [Text(faqs[i].$2, style: const TextStyle(fontSize: 12.5, height: 1.5, color: AppColors.textSecondary))],
                  ),
                  if (i != faqs.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        SettingsSectionTitle(tr('help_contact_title')),
        SettingsCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(labelText: tr('label_subject')),
                  validator: (v) => (v == null || v.trim().isEmpty) ? tr('validation_required') : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _messageController,
                  minLines: 4,
                  maxLines: 6,
                  decoration: InputDecoration(labelText: tr('label_message'), alignLabelWithHint: true),
                  validator: (v) => (v == null || v.trim().isEmpty) ? tr('validation_required') : null,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(_errorMessage!, style: const TextStyle(color: AppColors.goldDark, fontSize: 12.5)),
                ],
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _sending ? null : _send,
                  icon: _sending
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send_rounded, size: 17),
                  label: Text(tr('button_send_request')),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        SettingsSectionTitle(tr('help_requests_title')),
        if (_requests == null)
          const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
        else if (_requests!.isEmpty)
          SettingsCard(
            child: Text(tr('help_requests_empty'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
          )
        else
          for (final request in _requests!) ...[
            SettingsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(request.subject, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.navy))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.goldLight, borderRadius: BorderRadius.circular(10)),
                        child: Text(tr('status_open'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.goldDark)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(request.message, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(_formatDate(request.createdAt), style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}
