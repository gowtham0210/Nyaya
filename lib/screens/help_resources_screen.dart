import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localization/app_strings.dart';
import '../models/help_resource.dart';
import '../repositories/help_resources_repository.dart';
import '../services/api_exceptions.dart';
import '../state/nyaya_tabs.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import 'login_screen.dart';

const _verifiedGreen = Color(0xFF2E7D5B);
const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

enum _Status { loading, unauthenticated, error, loaded }

/// Help & Resources — pick a state and a support category to see the
/// matching helplines from the backend directory. One reusable screen; the
/// list is fetched per selection, never hardcoded here. Defaults to Tamil
/// Nadu / Women Safety (the user can change both).
class HelpResourcesScreen extends StatefulWidget {
  const HelpResourcesScreen({super.key});

  @override
  State<HelpResourcesScreen> createState() => _HelpResourcesScreenState();
}

class _HelpResourcesScreenState extends State<HelpResourcesScreen> {
  final _repository = HelpResourcesRepository();

  _Status _status = _Status.loading;
  String? _errorMessage;
  List<IndianState> _states = const [];
  List<SupportCategory> _categories = const [];
  IndianState? _state;
  SupportCategory? _category;
  List<HelpResource> _resources = const [];
  bool _loadingResources = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() => _status = _Status.loading);
    try {
      final results = await Future.wait([_repository.getStates(), _repository.getCategories()]);
      _states = results[0] as List<IndianState>;
      _categories = results[1] as List<SupportCategory>;
      _state = _states.where((s) => s.name == 'Tamil Nadu').firstOrNull ?? _states.firstOrNull;
      _category = _categories.where((c) => c.name == 'Women Safety').firstOrNull ?? _categories.firstOrNull;
      setState(() => _status = _Status.loaded);
      await _loadResources();
    } on UnauthenticatedException {
      setState(() => _status = _Status.unauthenticated);
    } on ApiException catch (e) {
      setState(() {
        _status = _Status.error;
        _errorMessage = e.message;
      });
    } on NetworkException catch (e) {
      setState(() {
        _status = _Status.error;
        _errorMessage = e.message;
      });
    }
  }

  Future<void> _loadResources() async {
    final state = _state;
    final category = _category;
    if (state == null || category == null) return;
    setState(() {
      _loadingResources = true;
      _errorMessage = null;
    });
    try {
      final items = await _repository.getResources(stateCode: state.code, categorySlug: category.slug);
      // Ignore a stale response if the user changed the selection meanwhile.
      if (!mounted || state != _state || category != _category) return;
      setState(() {
        _resources = items;
        _loadingResources = false;
      });
    } on UnauthenticatedException {
      if (mounted) setState(() => _status = _Status.unauthenticated);
    } on ApiException catch (e) {
      _failResources(e.message);
    } on NetworkException catch (e) {
      _failResources(e.message);
    }
  }

  void _failResources(String message) {
    if (!mounted) return;
    setState(() {
      _loadingResources = false;
      _status = _Status.error;
      _errorMessage = message;
    });
  }

  Future<void> _pickState() async {
    final picked = await _showPicker<IndianState>(
      title: tr('help_res_select_state'),
      items: _states,
      selected: _state,
      label: (s) => s.name,
    );
    if (picked != null && picked != _state) {
      setState(() => _state = picked);
      _loadResources();
    }
  }

  Future<void> _pickCategory() async {
    final picked = await _showPicker<SupportCategory>(
      title: tr('help_res_select_category'),
      items: _categories,
      selected: _category,
      label: (c) => c.name,
    );
    if (picked != null && picked != _category) {
      setState(() => _category = picked);
      _loadResources();
    }
  }

  Future<T?> _showPicker<T>({required String title, required List<T> items, required T? selected, required String Function(T) label}) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PickerSheet<T>(title: title, items: items, selected: selected, label: label),
    );
  }

  Future<void> _openSignIn() async {
    final signedIn = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const LoginScreen()));
    if (signedIn == true) _init();
  }

  Future<void> _launch(Uri uri) async {
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
    if (!opened && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(tr('help_res_open_failed'))));
    }
  }

  void _call(String number) => _launch(Uri(scheme: 'tel', path: number.replaceAll(RegExp(r'[^0-9+]'), '')));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.navy,
        title: Text(tr('help_res_title'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy)),
      ),
      bottomNavigationBar: const GlobalBottomNav(),
      body: SafeArea(top: false, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _Status.loading:
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      case _Status.unauthenticated:
        return _Message(icon: Icons.lock_outline, text: tr('help_res_signin'), actionLabel: tr('button_sign_in'), onAction: _openSignIn);
      case _Status.error:
        return _Message(
          icon: Icons.wifi_off_rounded,
          text: _errorMessage ?? tr('help_res_load_error'),
          actionLabel: tr('button_retry'),
          onAction: _init,
        );
      case _Status.loaded:
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            Text(tr('help_res_subtitle'), style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _SelectorCard(icon: Icons.location_on_outlined, label: tr('help_res_select_state'), value: _state?.name ?? '', onTap: _pickState)),
                const SizedBox(width: 10),
                Expanded(child: _SelectorCard(icon: Icons.shield_outlined, label: tr('help_res_select_category'), value: _category?.name ?? '', onTap: _pickCategory)),
              ],
            ),
            const SizedBox(height: 12),
            _buildSummary(),
            const SizedBox(height: 12),
            ..._buildResults(),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.muted),
                const SizedBox(width: 6),
                Expanded(child: Text(tr('help_res_emergency_note'), style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
              ],
            ),
          ],
        );
    }
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.goldLight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.beigeBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 15, color: AppColors.goldDark),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '${_state?.name ?? ''} • ${_category?.name ?? ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
          ),
          if (!_loadingResources) ...[
            const SizedBox(width: 8),
            Text(
              '${_resources.length} ${_resources.length == 1 ? tr('help_res_resource_one') : tr('help_res_resource_many')}',
              style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildResults() {
    if (_loadingResources) {
      return const [Padding(padding: EdgeInsets.symmetric(vertical: 36), child: Center(child: CircularProgressIndicator(strokeWidth: 2)))];
    }
    if (_resources.isEmpty) {
      return [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.beigeBorder),
          ),
          child: Column(
            children: [
              const Icon(Icons.search_off_rounded, size: 30, color: AppColors.muted),
              const SizedBox(height: 10),
              Text(tr('help_res_empty_title'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navy)),
              const SizedBox(height: 6),
              Text(tr('help_res_empty_body'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ];
    }
    return [
      for (final resource in _resources) ...[
        _ResourceCard(resource: resource, onCall: _call, onOpen: _launch),
        const SizedBox(height: 12),
      ],
    ];
  }
}

class _SelectorCard extends StatelessWidget {
  const _SelectorCard({required this.icon, required this.label, required this.value, required this.onTap});

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.beigeBorder),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.gold),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                    const SizedBox(height: 2),
                    Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.navy)),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.navy),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({required this.resource, required this.onCall, required this.onOpen});

  final HelpResource resource;
  final void Function(String number) onCall;
  final void Function(Uri uri) onOpen;

  String _date(DateTime d) => '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    final number = resource.primaryNumber;
    final site = resource.websiteUrl ?? resource.sourceUrl;
    final verifiedAt = resource.lastVerifiedAt;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.beigeBorder),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(resource.name, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.navy, height: 1.3)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (resource.isNational) _Chip(text: tr('help_res_national'), color: AppColors.goldDark, background: AppColors.goldLight),
                        resource.isVerified && verifiedAt != null
                            ? _Chip(text: '${tr('help_res_verified_on')}: ${_date(verifiedAt)}', color: _verifiedGreen, background: _verifiedGreen.withValues(alpha: 0.10), icon: Icons.check_circle_rounded)
                            : _Chip(text: tr('help_res_needs_verification'), color: AppColors.textSecondary, background: AppColors.background),
                      ],
                    ),
                    if (resource.tollFree != null) ...[
                      const SizedBox(height: 10),
                      _NumberRow(number: resource.tollFree!, label: resource.isNational ? '${tr('help_res_toll_free')} (All India)' : tr('help_res_toll_free')),
                    ],
                    if (resource.phoneNumber != null) ...[
                      const SizedBox(height: 8),
                      _NumberRow(number: resource.phoneNumber!, label: tr('help_res_phone')),
                    ],
                    if (resource.serviceHours != null) ...[
                      const SizedBox(height: 8),
                      Text('${tr('help_res_hours')}: ${resource.serviceHours}', style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                    ],
                  ],
                ),
              ),
              if (number != null) ...[
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => onCall(number),
                  icon: const Icon(Icons.call, size: 15),
                  label: Text(tr('help_res_call_now')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    minimumSize: const Size(0, 38),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Wrap(
            spacing: 18,
            runSpacing: 10,
            children: [
              _LinkRow(
                icon: Icons.language_rounded,
                title: tr('help_res_official_source'),
                subtitle: resource.sourceName,
                onTap: () => onOpen(Uri.parse(site)),
              ),
              if (resource.email != null)
                _LinkRow(
                  icon: Icons.mail_outline_rounded,
                  title: tr('help_res_email'),
                  subtitle: resource.email!,
                  onTap: () => onOpen(Uri(scheme: 'mailto', path: resource.email)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumberRow extends StatelessWidget {
  const _NumberRow({required this.number, required this.label});

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.phone_rounded, size: 15, color: AppColors.goldDark),
            const SizedBox(width: 6),
            Text(number, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.navy)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 21, top: 1),
          child: Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.color, required this.background, this.icon});

  final String text;
  final Color color;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 11, color: color), const SizedBox(width: 4)],
          Flexible(child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color))),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 240),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: AppColors.navy),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                  Text(subtitle, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, required this.actionLabel, required this.onAction});

  final IconData icon;
  final String text;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: AppColors.muted),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

/// A searchable bottom-sheet list used for both the state and category pickers.
class _PickerSheet<T> extends StatefulWidget {
  const _PickerSheet({required this.title, required this.items, required this.selected, required this.label});

  final String title;
  final List<T> items;
  final T? selected;
  final String Function(T) label;

  @override
  State<_PickerSheet<T>> createState() => _PickerSheetState<T>();
}

class _PickerSheetState<T> extends State<_PickerSheet<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final filtered = q.isEmpty ? widget.items : widget.items.where((i) => widget.label(i).toLowerCase().contains(q)).toList();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.72,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.beigeBorder, borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 14),
            Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.navy)),
            const SizedBox(height: 10),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: tr('help_res_search_hint'),
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text(tr('help_res_no_match'), style: const TextStyle(color: AppColors.textSecondary)))
                  : Material(
                      color: Colors.transparent,
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final isSelected = item == widget.selected;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              widget.label(item),
                              style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, color: AppColors.navy),
                            ),
                            trailing: isSelected ? const Icon(Icons.check_rounded, color: AppColors.gold) : null,
                            onTap: () => Navigator.of(context).pop(item),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
