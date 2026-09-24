import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../repositories/profile_repository.dart';
import '../services/api_exceptions.dart';
import '../theme/app_colors.dart';
import '../widgets/settings_page.dart';

/// Privacy & Security: change password (POST /users/me/change-password),
/// how many sign-ins are active on the account (GET /users/me/security),
/// and sign out everywhere (POST /users/me/logout-all). Pops with `true`
/// when the user ended their own session so the caller can reset itself.
class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  final _repository = ProfileRepository();
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _saving = false;
  String? _errorMessage;
  int? _activeSessions;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _loadSessions() async {
    try {
      final count = await _repository.getActiveSessions();
      if (mounted) setState(() => _activeSessions = count);
    } catch (_) {
      // The count is informational; the rest of the page still works.
    }
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      await _repository.changePassword(currentPassword: _currentController.text, newPassword: _newController.text);
      if (!mounted) return;
      _currentController.clear();
      _newController.clear();
      _confirmController.clear();
      showSettingsSnack(context, tr('password_updated_message'));
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } on NetworkException catch (e) {
      setState(() => _errorMessage = e.message);
    } on UnauthenticatedException {
      setState(() => _errorMessage = tr('profile_signin_message'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _logoutEverywhere() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(tr('button_logout_all')),
        content: Text(tr('logout_all_confirm')),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(tr('button_cancel'))),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(tr('button_logout'), style: const TextStyle(color: AppColors.goldDark)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _repository.logoutEverywhere();
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) showSettingsSnack(context, e.message);
    } on NetworkException catch (e) {
      if (mounted) showSettingsSnack(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPage(
      title: tr('placeholder_privacy_security'),
      children: [
        SettingsSectionTitle(tr('privacy_change_password')),
        SettingsCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _currentController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: tr('label_current_password')),
                  validator: (v) => (v == null || v.isEmpty) ? tr('validation_required') : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _newController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: tr('label_new_password')),
                  validator: (v) => (v == null || v.length < 8) ? tr('validation_password') : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: tr('label_confirm_password')),
                  validator: (v) => v != _newController.text ? tr('validation_passwords_mismatch') : null,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(_errorMessage!, style: const TextStyle(color: AppColors.goldDark, fontSize: 12.5)),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saving ? null : _changePassword,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  child: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(tr('button_update_password')),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        SettingsSectionTitle(tr('privacy_sessions_title')),
        SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
                    child: const Icon(Icons.devices_rounded, size: 19, color: AppColors.navy),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(tr('privacy_sessions_body'), style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.35)),
                  ),
                  Text(
                    _activeSessions == null ? '–' : '$_activeSessions',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.navy),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _logoutEverywhere,
                icon: const Icon(Icons.logout_rounded, size: 17),
                label: Text(tr('button_logout_all')),
                style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 46)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
