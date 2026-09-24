import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../services/notifications_service.dart';
import '../theme/app_colors.dart';
import '../widgets/settings_page.dart';

/// Notification preferences — the Daily Reminder switch schedules a real
/// on-device notification (see [NotificationsService]). There is no
/// server-side notification feed yet, so the list below is honestly empty.
class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _reminderEnabled = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    NotificationsService.isEnabled().then((value) {
      if (mounted) setState(() => _reminderEnabled = value);
    });
  }

  Future<void> _toggle(bool value) async {
    setState(() {
      _reminderEnabled = value;
      _busy = true;
    });
    final actuallyEnabled = await NotificationsService.setEnabled(value);
    if (!mounted) return;
    setState(() {
      _reminderEnabled = actuallyEnabled;
      _busy = false;
    });
    if (value && !actuallyEnabled) showSettingsSnack(context, tr('reminder_permission_denied'));
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: tr('label_notifications'),
      children: [
        SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.goldLight, shape: BoxShape.circle),
                    child: const Icon(Icons.notifications_active_outlined, color: AppColors.goldDark, size: 19),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr('label_daily_reminder'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navy)),
                        const SizedBox(height: 2),
                        Text(tr('daily_reminder_subtitle'), style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Switch(value: _reminderEnabled, activeThumbColor: AppColors.gold, onChanged: _busy ? null : _toggle),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 14, color: AppColors.muted),
                  const SizedBox(width: 6),
                  Expanded(child: Text(tr('notif_reminder_time_note'), style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        SettingsCard(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          child: Column(
            children: [
              const Icon(Icons.notifications_none_rounded, size: 34, color: AppColors.muted),
              const SizedBox(height: 10),
              Text(tr('notif_empty_title'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navy)),
              const SizedBox(height: 4),
              Text(tr('notif_empty_body'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
