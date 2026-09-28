import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import 'reminders_view_model.dart';
import 'widgets/settings_scaffold.dart';

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
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final viewModel = widget.viewModel;
        final settings = viewModel.settings;
        final time = TimeOfDay(hour: settings.hour, minute: settings.minute);
        final canChange = viewModel.ready && !viewModel.busy;
        return SettingsScaffold(
          title: l10n.profileReminders,
          children: [
            SettingsCard(
              children: [
                SwitchListTile(
                  key: const ValueKey('reminders.toggle'),
                  value: settings.enabled,
                  activeThumbColor: settingsGold,
                  title: Text(l10n.remindersToggle),
                  subtitle: Text(l10n.remindersToggleSubtitle),
                  onChanged: canChange
                      ? (enabled) => viewModel.setEnabled(enabled, _text())
                      : null,
                ),
                ListTile(
                  key: const ValueKey('reminders.time'),
                  leading: const Icon(Icons.schedule_rounded),
                  title: Text(l10n.remindersTime),
                  trailing: Text(
                    MaterialLocalizations.of(context).formatTimeOfDay(time),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: settingsNavy,
                    ),
                  ),
                  onTap: canChange ? _pickTime : null,
                ),
              ],
            ),
            if (viewModel.failed)
              _Warning(
                l10n.remindersFailed,
                key: const ValueKey('reminders.failed'),
              ),
            if (viewModel.permissionDenied)
              _Warning(
                l10n.remindersPermissionDenied,
                key: const ValueKey('reminders.denied'),
              ),
          ],
        );
      },
    );
  }
}

class _Warning extends StatelessWidget {
  const _Warning(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        text,
        style: const TextStyle(color: settingsDanger, height: 1.4),
      ),
    );
  }
}
