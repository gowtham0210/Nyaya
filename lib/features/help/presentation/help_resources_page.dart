import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/show_message.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import '../../../core/presentation/widgets/settings_scaffold.dart';
import '../data/link_opener.dart';
import 'help_resources_view_model.dart';

const _verifiedGreen = Color(0xFF1FA35B);

/// Legal help resources (spec 032): pick a state and a kind of help, then
/// call, email or open each contact.
class HelpResourcesPage extends StatefulWidget {
  const HelpResourcesPage({
    super.key,
    required this.viewModel,
    required this.openLink,
  });

  final HelpResourcesViewModel viewModel;
  final LinkOpener openLink;

  @override
  State<HelpResourcesPage> createState() => _HelpResourcesPageState();
}

class _HelpResourcesPageState extends State<HelpResourcesPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  Future<void> _open(Uri uri) async {
    final failed = context.l10n.helpResOpenFailed;
    if (!await widget.openLink(uri) && mounted) {
      showMessage(context, failed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final viewModel = widget.viewModel;
        return SettingsScaffold(
          title: l10n.profileHelpResources,
          children: [
            Text(
              l10n.helpResSubtitle,
              style: const TextStyle(color: settingsSupportText, height: 1.4),
            ),
            const SizedBox(height: 12),
            _EmergencyNote(onCall: () => _open(telLink('112'))),
            const SizedBox(height: 16),
            LoadStateView<HelpOptions>(
              state: viewModel.state,
              onRetry: viewModel.load,
              builder: (context, options) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<IndianState>(
                    key: const ValueKey('helpRes.state'),
                    initialValue: viewModel.selectedState,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.helpResState,
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                    items: [
                      for (final state in options.states)
                        DropdownMenuItem(value: state, child: Text(state.name)),
                    ],
                    onChanged: (state) {
                      if (state != null) {
                        viewModel.selectState(state);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<HelpCategory>(
                    key: const ValueKey('helpRes.category'),
                    initialValue: viewModel.selectedCategory,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.helpResCategory,
                      prefixIcon: const Icon(Icons.shield_outlined),
                    ),
                    items: [
                      for (final category in options.categories)
                        DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        ),
                    ],
                    onChanged: (category) {
                      if (category != null) {
                        viewModel.selectCategory(category);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  LoadStateView<List<HelpResource>>(
                    state: viewModel.resources,
                    onRetry: viewModel.reloadResources,
                    emptyMessage: l10n.helpResEmpty,
                    emptyIcon: Icons.search_off_rounded,
                    builder: (context, resources) => Column(
                      children: [
                        for (final resource in resources) ...[
                          _ResourceCard(resource: resource, onOpen: _open),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmergencyNote extends StatelessWidget {
  const _EmergencyNote({required this.onCall});

  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const ValueKey('helpRes.emergency'),
      color: settingsDanger.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onCall,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.emergency_outlined, color: settingsDanger),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.l10n.helpResEmergency,
                  style: const TextStyle(
                    color: settingsDanger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.call_rounded, color: settingsDanger),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({required this.resource, required this.onOpen});

  final HelpResource resource;
  final ValueChanged<Uri> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final verifiedAt = resource.verifiedAt;
    final callNumber = resource.callNumber;
    final email = resource.email;
    final website = resource.website;
    final source = resource.source;
    final hours = resource.hours;
    final key = 'helpRes.${resource.id}';
    return SettingsCard(
      key: ValueKey(key),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resource.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: settingsNavy,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (resource.isNational)
                    _Chip(l10n.helpResNational, color: settingsGold),
                  if (resource.isVerified && verifiedAt != null)
                    _Chip(
                      l10n.helpResVerified(
                        DateFormat.yMMMd(locale).format(verifiedAt),
                      ),
                      color: _verifiedGreen,
                    )
                  else
                    _Chip(
                      l10n.helpResNeedsVerification,
                      color: settingsSupportText,
                    ),
                ],
              ),
              if (resource.tollFree != null || resource.phone != null) ...[
                const SizedBox(height: 10),
                if (resource.tollFree case final tollFree?)
                  Text('${l10n.helpResTollFree}: $tollFree'),
                if (resource.phone case final phone?)
                  Text('${l10n.helpResPhone}: $phone'),
              ],
              if (hours != null) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.helpResHours(hours),
                  style: const TextStyle(color: settingsSupportText),
                ),
              ],
              if (callNumber != null) ...[
                const SizedBox(height: 12),
                FilledButton.icon(
                  key: ValueKey('$key.call'),
                  onPressed: () => onOpen(telLink(callNumber)),
                  icon: const Icon(Icons.call_rounded, size: 18),
                  label: Text(l10n.helpResCall(callNumber)),
                  style: FilledButton.styleFrom(
                    backgroundColor: settingsNavy,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (email != null)
          ListTile(
            key: ValueKey('$key.email'),
            leading: const Icon(Icons.mail_outline_rounded),
            title: Text(l10n.helpResEmail),
            subtitle: Text(email),
            onTap: () => onOpen(Uri(scheme: 'mailto', path: email)),
          ),
        if (website != null)
          ListTile(
            key: ValueKey('$key.website'),
            leading: const Icon(Icons.language_rounded),
            title: Text(l10n.helpResWebsite),
            subtitle: Text(website.host),
            onTap: () => onOpen(website),
          ),
        if (source != null)
          ListTile(
            key: ValueKey('$key.source'),
            leading: const Icon(Icons.verified_outlined),
            title: Text(l10n.helpResSource(resource.sourceName)),
            subtitle: Text(source.host),
            onTap: () => onOpen(source),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}
