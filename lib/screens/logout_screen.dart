import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../repositories/profile_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/settings_page.dart';

/// Logout page. "Log out" revokes the refresh token on the server and
/// clears the local session, then pops with `true` so the Profile screen
/// can reset itself; "Stay signed in" pops with nothing.
class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final _repository = ProfileRepository();
  bool _busy = false;

  Future<void> _logout() async {
    setState(() => _busy = true);
    await _repository.logout();
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: tr('settings_logout_title'),
      children: [
        const SizedBox(height: 24),
        SettingsCard(
          padding: const EdgeInsets.fromLTRB(22, 30, 22, 24),
          child: Column(
            children: [
              Container(
                width: 68,
                height: 68,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.goldLight, shape: BoxShape.circle),
                child: const Icon(Icons.logout_rounded, size: 30, color: AppColors.goldDark),
              ),
              const SizedBox(height: 18),
              Text(
                tr('logout_screen_heading'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.navy),
              ),
              const SizedBox(height: 8),
              Text(
                tr('logout_screen_body'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.5, height: 1.5, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 26),
              ElevatedButton(
                onPressed: _busy ? null : _logout,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: _busy
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(tr('button_logout')),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _busy ? null : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                child: Text(tr('button_stay_signed_in')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
