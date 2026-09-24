import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../models/profile_stats.dart';
import '../models/user_profile.dart';
import '../repositories/profile_repository.dart';
import '../services/api_exceptions.dart';
import '../state/app_language.dart';
import '../state/nyaya_tabs.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../widgets/initials_avatar.dart';
import '../widgets/nyaya_app_bar.dart';
import 'about_nyaya_screen.dart';
import 'edit_profile_screen.dart';
import 'help_support_screen.dart';
import 'login_screen.dart';
import 'logout_screen.dart';
import 'notifications_settings_screen.dart';
import 'placeholder_screen.dart';
import 'privacy_security_screen.dart';

enum _Status { loading, unauthenticated, error, loaded }

/// (native name, English name, language code). Selecting one calls
/// [AppLanguage.set], which re-renders every screen's `tr()` calls in that
/// language — not just this one. Only the static UI copy translates; real
/// backend content (articles, questions, leaderboard names) is stored in
/// one language server-side and stays as returned.
const _languages = [
  ('English', 'English', 'en'),
  ('हिंदी', 'Hindi', 'hi'),
  ('தமிழ்', 'Tamil', 'ta'),
  ('తెలుగు', 'Telugu', 'te'),
  ('ಕನ್ನಡ', 'Kannada', 'kn'),
];

/// The NYAYA Profile screen — the real signed-in user's name/email/phone
/// and real usage stats (points, streak, quizzes completed, categories
/// explored), all from GET /api/v1/users/me* via [ProfileRepository]. No
/// invented numbers: a fresh account genuinely shows zeros.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _repository = ProfileRepository();

  _Status _status = _Status.loading;
  UserProfile? _profile;
  ProfileStats? _stats;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _selectLanguage(String code) => AppLanguage.set(code);

  Future<void> _load() async {
    setState(() => _status = _Status.loading);
    try {
      final results = await Future.wait([_repository.getProfile(), _repository.getStats()]);
      setState(() {
        _profile = results[0] as UserProfile;
        _stats = results[1] as ProfileStats;
        _status = _Status.loaded;
      });
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

  Future<void> _openSignIn() async {
    final signedIn = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const LoginScreen()));
    if (signedIn == true) _load();
  }

  void _openPlaceholder(String title) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)));
  }

  Future<void> _editProfile() async {
    final profile = _profile;
    if (profile == null) return;
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => EditProfileScreen(profile: profile)),
    );
    if (saved == true) _load();
  }

  Future<void> _openSettingsPage(Widget page) async {
    final signedOut = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => page));
    if (signedOut == true) {
      NyayaTabs.current.value = 0;
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NyayaAppBar(onNotificationTap: () => _openPlaceholder(tr('label_notifications'))),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            children: _buildBody(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBody() {
    switch (_status) {
      case _Status.loading:
        return const [
          Padding(padding: EdgeInsets.symmetric(vertical: 60), child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
        ];

      case _Status.unauthenticated:
        return [
          _StatusCard(
            icon: Icons.lock_outline,
            message: tr('profile_signin_message'),
            actionLabel: tr('button_sign_in'),
            onAction: _openSignIn,
          ),
        ];

      case _Status.error:
        return [
          _StatusCard(
            icon: Icons.wifi_off_rounded,
            message: _errorMessage ?? tr('profile_error_default'),
            actionLabel: tr('button_retry'),
            onAction: _load,
          ),
        ];

      case _Status.loaded:
        final profile = _profile!;
        final stats = _stats!;
        return [
          _ProfileCard(profile: profile, onEdit: _editProfile),
          const SizedBox(height: 18),
          _StatisticsSection(stats: stats),
          const SizedBox(height: 18),
          _LanguageSection(selected: AppLanguage.current.value, onSelect: _selectLanguage),
          const SizedBox(height: 18),
          _SettingsSection(
            onNotifications: () => _openSettingsPage(const NotificationsSettingsScreen()),
            onPrivacy: () => _openSettingsPage(const PrivacySecurityScreen()),
            onHelp: () => _openSettingsPage(const HelpSupportScreen()),
            onAbout: () => _openSettingsPage(const AboutNyayaScreen()),
            onLogout: () => _openSettingsPage(const LogoutScreen()),
          ),
        ];
    }
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile, required this.onEdit});

  final UserProfile profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final professionKey = kProfessionLabelKeys[profile.profession];
    final phone = profile.phone;
    // Keeps the email/phone lines clear of the corner Edit button.
    final reserve = 44.0 + tr('edit_profile').length * 7.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.navyDark],
        ),
        boxShadow: AppShadows.raised,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -22,
            child: Icon(Icons.balance_rounded, size: 150, color: Colors.white.withValues(alpha: 0.05)),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.gold, width: 2)),
                      child: InitialsAvatar(name: profile.fullName, size: 68, avatarUrl: profile.avatarUrl),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.navyDark,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(BorderSide(color: AppColors.gold, width: 1.5)),
                        ),
                        child: const Icon(Icons.photo_camera_outlined, color: AppColors.gold, size: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.2),
                      ),
                      if (professionKey != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.gold.withValues(alpha: 0.6)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified_rounded, size: 13, color: AppColors.gold),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  tr(professionKey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.goldLight),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Padding(padding: EdgeInsets.only(right: reserve), child: _ProfileInfoRow(icon: Icons.mail_outline_rounded, text: profile.email)),
                      if (phone != null && phone.isNotEmpty) ...[
                        const SizedBox(height: 7),
                        Padding(padding: EdgeInsets.only(right: reserve), child: _ProfileInfoRow(icon: Icons.phone_outlined, text: phone)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 14,
            bottom: 14,
            child: Material(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onEdit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_outlined, size: 14, color: AppColors.navyDark),
                      const SizedBox(width: 6),
                      Text(
                        tr('edit_profile'),
                        maxLines: 1,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.navyDark),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.goldLight),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
          ),
        ),
      ],
    );
  }
}

class _StatisticsSection extends StatelessWidget {
  const _StatisticsSection({required this.stats});

  final ProfileStats stats;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      (Icons.menu_book_outlined, '${stats.categoriesExplored}', tr('stat_categories_explored'), AppColors.navy),
      (Icons.description_outlined, '${stats.topicsCompleted}', tr('stat_topics_completed'), AppColors.goldDark),
      (Icons.emoji_events_outlined, '${stats.pointsEarned}', tr('stat_points_earned'), AppColors.navySecondary),
      (Icons.local_fire_department_outlined, '${stats.dayStreak}', tr('stat_day_streak'), AppColors.gold),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(icon: Icons.bar_chart_rounded, title: tr('my_statistics')),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < tiles.length; i++) ...[
              if (i != 0) const SizedBox(width: 10),
              Expanded(child: _StatTile(icon: tiles[i].$1, value: tiles[i].$2, label: tiles[i].$3, color: tiles[i].$4)),
            ],
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.value, required this.label, required this.color});

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.beigeBorder),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.navy)),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.25, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _LanguageSection extends StatelessWidget {
  const _LanguageSection({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.beigeBorder),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(icon: Icons.language_rounded, title: tr('section_language')),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(tr('language_subtitle'), style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final (native, english, code) in _languages)
                _LanguageChip(native: native, english: english, selected: code == selected, onTap: () => onSelect(code)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({required this.native, required this.english, required this.selected, required this.onTap});

  final String native;
  final String english;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 84,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold.withValues(alpha: 0.10) : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.gold : AppColors.beigeBorder, width: selected ? 1.4 : 1),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: AppColors.goldLight, shape: BoxShape.circle),
                  child: const Icon(Icons.language_rounded, color: AppColors.goldDark, size: 17),
                ),
                if (selected)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                      child: const Icon(Icons.check, color: Colors.white, size: 11),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(native, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navy)),
            Text(english, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.onNotifications,
    required this.onPrivacy,
    required this.onHelp,
    required this.onAbout,
    required this.onLogout,
  });

  final VoidCallback onNotifications;
  final VoidCallback onPrivacy;
  final VoidCallback onHelp;
  final VoidCallback onAbout;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.beigeBorder),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: _SectionHeader(icon: Icons.settings_outlined, title: tr('account_settings')),
          ),
          _SettingsRow(
            icon: Icons.notifications_none_rounded,
            title: tr('label_notifications'),
            subtitle: tr('settings_notifications_subtitle'),
            onTap: onNotifications,
          ),
          _SettingsRow(
            icon: Icons.shield_outlined,
            title: tr('placeholder_privacy_security'),
            subtitle: tr('settings_privacy_subtitle'),
            onTap: onPrivacy,
          ),
          _SettingsRow(
            icon: Icons.help_outline_rounded,
            title: tr('placeholder_help_support'),
            subtitle: tr('settings_help_subtitle'),
            onTap: onHelp,
          ),
          _SettingsRow(
            icon: Icons.info_outline_rounded,
            title: tr('placeholder_about_nyaya'),
            subtitle: tr('settings_about_subtitle'),
            onTap: onAbout,
          ),
          _SettingsRow(
            icon: Icons.logout_rounded,
            title: tr('settings_logout_title'),
            subtitle: tr('settings_logout_subtitle'),
            onTap: onLogout,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
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
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.muted, size: 20),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.navy),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.navy)),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.icon, required this.message, this.actionLabel, this.onAction});

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.beigeBorder),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.muted, size: 30),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
          if (actionLabel != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                minimumSize: const Size(0, 42),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
