import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/initials_avatar.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import 'profile_view_model.dart';

const _pageBackground = Color(0xFFF8F6F2);
const _navy = Color(0xFF11233B);
const _gold = Color(0xFFB9823A);
const _supportText = Color(0xFF5E6878);
const _cardBorder = Color(0xFFECE5DB);
const _danger = Color(0xFFD64545);

/// Places Profile links to (spec 021); each is a later screen.
enum ProfileEntry {
  editProfile,
  language,
  reminders,
  privacy,
  helpSupport,
  helpResources,
  about,
}

/// The Profile tab (spec 021): who's signed in, their stats, settings
/// entries and log out.
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.viewModel,
    required this.onEntrySelected,
    required this.onLogout,
  });

  final ProfileViewModel viewModel;
  final ValueChanged<ProfileEntry> onEntrySelected;

  /// Called after the learner confirms logging out.
  final Future<void> Function() onLogout;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewModel = widget.viewModel;
    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) => ListView(
            key: const ValueKey('profile.scroll'),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            children: [
              LoadStateView<ProfileOverview>(
                state: viewModel.state,
                onRetry: viewModel.load,
                emptyMessage: '',
                builder: (context, overview) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(
                      profile: overview.profile,
                      onEdit: () =>
                          widget.onEntrySelected(ProfileEntry.editProfile),
                    ),
                    const SizedBox(height: 24),
                    _Heading(l10n.profileStatsTitle),
                    const SizedBox(height: 12),
                    _StatsGrid(stats: overview.stats),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _Heading(l10n.profileSettingsTitle),
              const SizedBox(height: 12),
              _EntryList(onSelected: widget.onEntrySelected),
              const SizedBox(height: 16),
              _LogoutTile(onLogout: widget.onLogout),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.profile, required this.onEdit});

  final UserProfile profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final profession = profile.profession;
    return Row(
      children: [
        InitialsAvatar(name: profile.fullName, avatarUrl: profile.avatarUrl),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
              if (profession != null) ...[
                const SizedBox(height: 2),
                Text(
                  profession,
                  style: const TextStyle(fontSize: 14, color: _supportText),
                ),
              ],
              const SizedBox(height: 6),
              OutlinedButton.icon(
                key: const ValueKey('profile.edit'),
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: Text(context.l10n.profileEdit),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _navy,
                  side: const BorderSide(color: _cardBorder),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: _navy,
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final ProfileStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tiles = [
      _StatTile(
        id: 'streak',
        icon: Icons.local_fire_department_outlined,
        value: stats.streak,
        label: l10n.profileStatStreak,
      ),
      _StatTile(
        id: 'categories',
        icon: Icons.menu_book_outlined,
        value: stats.categoriesExplored,
        label: l10n.profileStatCategories,
      ),
      _StatTile(
        id: 'quizzes',
        icon: Icons.task_alt_rounded,
        value: stats.quizzesCompleted,
        label: l10n.profileStatQuizzes,
      ),
      _StatTile(
        id: 'points',
        icon: Icons.emoji_events_outlined,
        value: stats.points,
        label: l10n.profileStatPoints,
      ),
    ];
    return Column(
      children: [
        for (var row = 0; row < tiles.length; row += 2) ...[
          if (row > 0) const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: tiles[row]),
                const SizedBox(width: 12),
                Expanded(child: tiles[row + 1]),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.id,
    required this.icon,
    required this.value,
    required this.label,
  });

  final String id;
  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        key: ValueKey('profile.stat.$id'),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: _gold, size: 22),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _navy,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: _supportText),
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryList extends StatelessWidget {
  const _EntryList({required this.onSelected});

  final ValueChanged<ProfileEntry> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final entries = [
      (ProfileEntry.language, Icons.language_rounded, l10n.profileLanguage),
      (
        ProfileEntry.reminders,
        Icons.notifications_none_rounded,
        l10n.profileReminders,
      ),
      (ProfileEntry.privacy, Icons.lock_outline_rounded, l10n.profilePrivacy),
      (
        ProfileEntry.helpSupport,
        Icons.support_agent_rounded,
        l10n.profileHelpSupport,
      ),
      (
        ProfileEntry.helpResources,
        Icons.balance_rounded,
        l10n.profileHelpResources,
      ),
      (ProfileEntry.about, Icons.info_outline_rounded, l10n.profileAbout),
    ];
    return _Card(
      children: [
        for (final (index, (entry, icon, label)) in entries.indexed) ...[
          if (index > 0) const Divider(height: 1, color: _cardBorder),
          ListTile(
            key: ValueKey('profile.entry.${entry.name}'),
            leading: Icon(icon, color: _navy),
            title: Text(label, style: const TextStyle(color: _navy)),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: _supportText,
            ),
            onTap: () => onSelected(entry),
          ),
        ],
      ],
    );
  }
}

class _LogoutTile extends StatelessWidget {
  const _LogoutTile({required this.onLogout});

  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _Card(
      children: [
        ListTile(
          key: const ValueKey('profile.logout'),
          leading: const Icon(Icons.logout_rounded, color: _danger),
          title: Text(
            l10n.profileLogout,
            style: const TextStyle(color: _danger, fontWeight: FontWeight.w600),
          ),
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Text(l10n.profileLogoutConfirmTitle),
                content: Text(l10n.profileLogoutConfirmBody),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text(l10n.commonCancel),
                  ),
                  TextButton(
                    key: const ValueKey('profile.logout.confirm'),
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    style: TextButton.styleFrom(foregroundColor: _danger),
                    child: Text(l10n.profileLogout),
                  ),
                ],
              ),
            );
            if (confirmed == true) {
              await onLogout();
            }
          },
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}
