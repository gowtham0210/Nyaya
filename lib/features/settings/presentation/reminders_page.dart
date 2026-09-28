import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import 'reminders_view_model.dart';

const _pageBackground = Color(0xFFF8F6F2);
const _navy = Color(0xFF11233B);
const _gold = Color(0xFFB9823A);
const _cardBorder = Color(0xFFECE5DB);
const _danger = Color(0xFFD64545);

/// Daily practice reminders (spec 029): a switch and a time.
class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key, required this.viewModel});

  final RemindersViewModel viewModel;

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  ReminderText _text() {
    final l10n = context.l10n;
    return (
      title: l10n.appTitle,
      body: l10n.reminderNotificationBody,
      channelName: l10n.reminderChannelName,
    );
  }

  Future<void> _pickTime() async {
    final settings = widget.viewModel.settings;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.hour, minute: settings.minute),
    );
    if (picked == null || !mounted) {
      return;
    }
    await widget.viewModel.setTime(
      hour: picked.hour,
      minute: picked.minute,
      text: _text(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        foregroundColor: _navy,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.profileReminders),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final viewModel = widget.viewModel;
          final settings = viewModel.settings;
          final time = TimeOfDay(hour: settings.hour, minute: settings.minute);
          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            children: [
              Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: _cardBorder),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    SwitchListTile(
                      key: const ValueKey('reminders.toggle'),
                      value: settings.enabled,
                      activeThumbColor: _gold,
                      title: Text(l10n.remindersToggle),
                      subtitle: Text(l10n.remindersToggleSubtitle),
                      onChanged: viewModel.ready && !viewModel.busy
                          ? (enabled) => viewModel.setEnabled(enabled, _text())
                          : null,
                    ),
                    const Divider(height: 1, color: _cardBorder),
                    ListTile(
                      key: const ValueKey('reminders.time'),
                      leading: const Icon(Icons.schedule_rounded),
                      title: Text(l10n.remindersTime),
                      trailing: Text(
                        MaterialLocalizations.of(context).formatTimeOfDay(time),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _navy,
                        ),
                      ),
                      onTap: viewModel.ready && !viewModel.busy
                          ? _pickTime
                          : null,
                    ),
                  ],
                ),
              ),
              if (viewModel.failed) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.remindersFailed,
                  key: const ValueKey('reminders.failed'),
                  style: const TextStyle(color: _danger, height: 1.4),
                ),
              ],
              if (viewModel.permissionDenied) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.remindersPermissionDenied,
                  key: const ValueKey('reminders.denied'),
                  style: const TextStyle(color: _danger, height: 1.4),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
