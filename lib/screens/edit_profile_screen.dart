import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../localization/app_strings.dart';
import '../models/user_profile.dart';
import '../repositories/profile_repository.dart';
import '../services/api_exceptions.dart';
import '../services/notifications_service.dart';
import '../state/app_language.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../widgets/initials_avatar.dart';

/// Canonical (English) profession values, stored as-is in the backend and
/// mapped to a translated label for display — same pattern as legal
/// updates' category filter, so the stored value stays stable across
/// language changes.
const kProfessionLabelKeys = {
  'Law Student': 'profession_law_student',
  'Lawyer / Advocate': 'profession_lawyer',
  'Police': 'profession_police',
  'Public': 'profession_public',
  'Other': 'profession_other',
};

const _languageOptions = [
  ('English', 'English', 'en'),
  ('हिंदी', 'Hindi', 'hi'),
  ('தமிழ்', 'Tamil', 'ta'),
  ('తెలుగు', 'Telugu', 'te'),
  ('ಕನ್ನಡ', 'Kannada', 'kn'),
];

/// The full-page "Edit Profile" screen (Personal Information +
/// Preferences), replacing the old bottom sheet. Full name, profession and
/// phone save via PATCH /users/me; email is shown but not editable here
/// (the backend has no change-email flow); Default Language reuses the
/// same [AppLanguage] mechanism as the Profile tab; Daily Reminder is a
/// real local notification (see [NotificationsService]), not a decorative
/// switch.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _repository = ProfileRepository();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  String? _profession;
  bool _reminderEnabled = false;
  bool _isSaving = false;
  bool _isUploadingAvatar = false;
  String? _errorMessage;
  String? _avatarUrl;

  static const _phoneCountryCode = '+91';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    final phone = widget.profile.phone ?? '';
    _phoneController = TextEditingController(
      text: phone.startsWith(_phoneCountryCode) ? phone.substring(_phoneCountryCode.length) : phone,
    );
    _profession = kProfessionLabelKeys.containsKey(widget.profile.profession) ? widget.profile.profession : null;
    _avatarUrl = widget.profile.avatarUrl;
    NotificationsService.isEnabled().then((value) {
      if (mounted) setState(() => _reminderEnabled = value);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });
    try {
      final phoneDigits = _phoneController.text.trim();
      await _repository.updateProfile(
        fullName: _nameController.text.trim(),
        phone: phoneDigits.isEmpty ? null : '$_phoneCountryCode$phoneDigits',
        profession: _profession,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(tr('profile_updated_message'))));
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } on NetworkException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _toggleReminder(bool value) async {
    setState(() => _reminderEnabled = value);
    final actuallyEnabled = await NotificationsService.setEnabled(value);
    if (!mounted) return;
    if (value && !actuallyEnabled) {
      setState(() => _reminderEnabled = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(tr('reminder_permission_denied'))));
    }
  }

  Future<void> _changeAvatar() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AvatarSourceSheet(),
    );
    if (source == null) return;

    final picker = ImagePicker();
    XFile? picked;
    try {
      picked = await picker.pickImage(source: source, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }
    if (picked == null) return;

    setState(() => _isUploadingAvatar = true);
    try {
      final updated = await _repository.uploadAvatar(File(picked.path));
      if (!mounted) return;
      setState(() => _avatarUrl = updated.avatarUrl);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(tr('profile_updated_message'))));
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.message)));
      }
    } on NetworkException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isUploadingAvatar = false);
    }
  }

  Future<void> _openLanguagePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _LanguagePickerSheet(),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.navy,
        title: Text(tr('edit_profile'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy)),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  InitialsAvatar(name: widget.profile.fullName, size: 88, avatarUrl: _avatarUrl),
                  if (_isUploadingAvatar)
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        ),
                      ),
                    ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _isUploadingAvatar ? null : _changeAvatar,
                      child: Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
                        ),
                        child: const Icon(Icons.photo_camera_outlined, color: Colors.white, size: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Text(tr('personal_information'), style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.navy)),
            const SizedBox(height: 12),
            _FieldCard(
              label: tr('label_full_name_field'),
              icon: Icons.person_outline,
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(border: InputBorder.none, isDense: true),
              ),
            ),
            const SizedBox(height: 12),
            _FieldCard(
              label: tr('label_profession'),
              icon: Icons.work_outline,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _profession,
                  isExpanded: true,
                  hint: Text(tr('label_profession'), style: const TextStyle(color: AppColors.muted, fontSize: 13.5)),
                  items: kProfessionLabelKeys.entries
                      .map((entry) => DropdownMenuItem(value: entry.key, child: Text(tr(entry.value))))
                      .toList(),
                  onChanged: (value) => setState(() => _profession = value),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _FieldCard(
              label: tr('label_email_address'),
              icon: Icons.mail_outline,
              child: Text(
                widget.profile.email,
                style: const TextStyle(fontSize: 13.5, color: AppColors.muted),
              ),
            ),
            const SizedBox(height: 12),
            _FieldCard(
              label: tr('label_phone_number'),
              icon: Icons.phone_outlined,
              child: Row(
                children: [
                  const Text(_phoneCountryCode, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                    ),
                  ),
                ],
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(_errorMessage!, style: const TextStyle(color: AppColors.goldDark, fontSize: 12.5)),
            ],
            const SizedBox(height: 22),
            Text(tr('section_preferences'), style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.navy)),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _openLanguagePicker,
              child: _PreferenceRow(
                icon: Icons.language_rounded,
                title: tr('label_default_language'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _languageOptions.firstWhere((l) => l.$3 == AppLanguage.current.value, orElse: () => _languageOptions[0]).$2,
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.muted, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            _PreferenceRow(
              icon: Icons.notifications_active_outlined,
              title: tr('label_daily_reminder'),
              subtitle: tr('daily_reminder_subtitle'),
              trailing: Switch(
                value: _reminderEnabled,
                activeThumbColor: AppColors.gold,
                onChanged: _toggleReminder,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save_outlined, size: 18),
              label: Text(tr('button_save_changes')),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({required this.label, required this.icon, required this.child});

  final String label;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.beigeBorder),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.goldDark),
              const SizedBox(width: 10),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({required this.icon, required this.title, this.subtitle, required this.trailing});

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.beigeBorder),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
            child: Icon(icon, size: 17, color: AppColors.navy),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                ],
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.beigeBorder, borderRadius: BorderRadius.circular(4))),
          ),
          const SizedBox(height: 16),
          Text(tr('label_default_language'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.navy)),
          const SizedBox(height: 14),
          ValueListenableBuilder<String>(
            valueListenable: AppLanguage.current,
            builder: (context, selected, _) {
              return Column(
                children: [
                  for (final (native, english, code) in _languageOptions)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        code == selected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: code == selected ? AppColors.gold : AppColors.muted,
                      ),
                      title: Text('$native ($english)', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                      onTap: () async {
                        await AppLanguage.set(code);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AvatarSourceSheet extends StatelessWidget {
  const _AvatarSourceSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.beigeBorder, borderRadius: BorderRadius.circular(4))),
          ),
          const SizedBox(height: 16),
          Text(tr('choose_photo_source'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.navy)),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.photo_camera_outlined, color: AppColors.goldDark),
            title: Text(tr('source_camera'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.photo_library_outlined, color: AppColors.goldDark),
            title: Text(tr('source_gallery'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}
