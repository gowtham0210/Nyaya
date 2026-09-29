import 'package:flutter/material.dart';

import '../../../app/app_session.dart';
import '../../../app/quiz_history_store.dart';
import '../../auth/presentation/sign_in_page.dart';
import '../../goal_selection/presentation/goal_selection_page.dart';
import '../../goal_selection/presentation/goal_selection_view_model.dart';
import '../../home/presentation/home_page.dart';
import '../../home/presentation/home_view_model.dart';
import '../../leaderboard/presentation/leaderboard_page.dart';
import 'profile_view_model.dart';

/// Home's "Profile" tab: the signed-in user's details, their learning
/// goal, quiz stats, and recent activity — with real editing, goal
/// switching, and sign-out, all persisted through [AppSession] (or the
/// injected callbacks, for testing) since there is no backend yet.
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    this.viewModel,
    this.onBackPressed,
    this.onNavigationSelected,
    this.onSaveProfile,
    this.onChangeGoal,
    this.onSignOut,
    this.onViewLeaderboard,
    this.onStartQuizPressed,
  });

  final ProfileViewModel? viewModel;
  final VoidCallback? onBackPressed;
  final ValueChanged<int>? onNavigationSelected;
  final void Function(String fullName, String email)? onSaveProfile;
  final ValueChanged<String>? onChangeGoal;
  final VoidCallback? onSignOut;
  final VoidCallback? onViewLeaderboard;
  final VoidCallback? onStartQuizPressed;

  static const _activeNavigationIndex = 4;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileViewModel _viewModel = widget.viewModel ?? ProfileViewModel();

  static const _navigationItems = HomeViewModel();

  /// The backend stats arrive after the first build, so the parent rebuilds
  /// this page with a new view model. Without adopting it here the `late`
  /// field above would keep the very first, statless one forever.
  @override
  void didUpdateWidget(ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final incoming = widget.viewModel;
    if (incoming != null && !identical(incoming, oldWidget.viewModel)) {
      _viewModel = incoming;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomePage.pageBackground,
      bottomNavigationBar: HomeBottomNavigationBar(
        items: _navigationItems.navigationItems,
        activeIndex: ProfilePage._activeNavigationIndex,
        onSelected: (index) {
          final callback = widget.onNavigationSelected;
          if (callback != null) {
            callback(index);
            return;
          }
          if (index == ProfilePage._activeNavigationIndex) {
            return;
          }
          Navigator.of(context).maybePop();
        },
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    key: const ValueKey('profile.back'),
                    onPressed: () {
                      final callback = widget.onBackPressed;
                      if (callback != null) {
                        callback();
                        return;
                      }
                      Navigator.of(context).maybePop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: HomePage.heroBackground,
                    ),
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: HomePage.heroBackground,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                children: [
                  _ProfileHeroCard(
                    viewModel: _viewModel,
                    onEditPressed: _openEditProfileDialog,
                    onRankPressed: _openLeaderboard,
                  ),
                  const SizedBox(height: 20),
                  _StatisticsCard(viewModel: _viewModel),
                  const SizedBox(height: 20),
                  _MenuCard(
                    title: 'My Learning',
                    rows: [
                      _MenuRow(
                        key: const ValueKey('profile.learning.continue'),
                        icon: Icons.play_circle_outline_rounded,
                        title: 'Continue Learning',
                        subtitle: 'Pick up where you left off',
                        onTap: _startQuiz,
                      ),
                      _MenuRow(
                        key: const ValueKey('profile.learning.bookmarks'),
                        icon: Icons.bookmark_border_rounded,
                        title: 'Bookmarks',
                        subtitle: 'Saved topics & notes',
                        onTap: () => _showComingSoon(context, 'Bookmarks'),
                      ),
                      _MenuRow(
                        key: const ValueKey('profile.learning.quizHistory'),
                        icon: Icons.fact_check_outlined,
                        title: 'Quiz History',
                        subtitle: 'Check your attempt history',
                        onTap: () => _showComingSoon(context, 'Quiz History'),
                      ),
                      _MenuRow(
                        key: const ValueKey('profile.learning.downloads'),
                        icon: Icons.download_outlined,
                        title: 'Downloads',
                        subtitle: 'Access your downloaded quizzes',
                        onTap: () => _showComingSoon(context, 'Downloads'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle('Learning Goal'),
                  const SizedBox(height: 12),
                  _GoalCard(
                    viewModel: _viewModel,
                    onChangePressed: _openGoalPicker,
                  ),
                  const SizedBox(height: 20),
                  _MenuCard(
                    title: 'Account',
                    rows: [
                      _MenuRow(
                        key: const ValueKey('profile.account.editProfile'),
                        icon: Icons.person_outline_rounded,
                        title: 'Edit Profile',
                        subtitle: 'Manage your personal information',
                        onTap: _openEditProfileDialog,
                      ),
                      _MenuRow(
                        key: const ValueKey('profile.account.settings'),
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        subtitle: 'App preferences and controls',
                        onTap: () => _showComingSoon(context, 'Settings'),
                      ),
                      _MenuRow(
                        key: const ValueKey('profile.account.helpSupport'),
                        icon: Icons.headset_mic_outlined,
                        title: 'Help & Support',
                        subtitle: 'Get help and contact support',
                        onTap: () => _showComingSoon(context, 'Help & Support'),
                      ),
                      _MenuRow(
                        key: const ValueKey('profile.signOut'),
                        icon: Icons.logout_rounded,
                        title: 'Logout',
                        subtitle: 'Sign out from your account',
                        onTap: _confirmSignOut,
                        iconColor: const Color(0xFFD64545),
                        titleColor: const Color(0xFFD64545),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _SectionTitle('Recent Activity'),
                  const SizedBox(height: 12),
                  _RecentActivity(
                    viewModel: _viewModel,
                    onStartQuizPressed: _startQuiz,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditProfileDialog() async {
    final result = await showDialog<_EditProfileResult>(
      context: context,
      builder: (dialogContext) => _EditProfileDialog(
        initialFullName: _viewModel.fullName,
        initialEmail: _viewModel.email,
      ),
    );
    if (result == null) {
      return;
    }

    final callback = widget.onSaveProfile;
    if (callback != null) {
      callback(result.fullName, result.email);
    } else {
      AppSession.saveProfile(fullName: result.fullName, email: result.email);
    }

    setState(() {
      _viewModel = ProfileViewModel(
        fullName: result.fullName,
        email: result.email,
        goalId: _viewModel.goalId,
        attempts: _viewModel.attempts,
        memberSince: _viewModel.memberSince,
        memberSinceProvided: true,
        stats: _viewModel.stats,
      );
    });
  }

  Future<void> _openGoalPicker() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (goalContext) => GoalSelectionPage(
          viewModel: GoalSelectionViewModel()
            ..selectedGoalId = _viewModel.goalId ?? 'learn-law-for-life',
          onContinue: (goalId) => Navigator.of(goalContext).pop(goalId),
        ),
      ),
    );
    if (result == null) {
      return;
    }

    final callback = widget.onChangeGoal;
    if (callback != null) {
      callback(result);
    } else {
      AppSession.saveGoal(result);
    }

    setState(() {
      _viewModel = ProfileViewModel(
        fullName: _viewModel.fullName,
        email: _viewModel.email,
        goalId: result,
        attempts: _viewModel.attempts,
        memberSince: _viewModel.memberSince,
        memberSinceProvided: true,
        stats: _viewModel.stats,
      );
    });
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label is not wired yet.')));
  }

  void _openLeaderboard() {
    final callback = widget.onViewLeaderboard;
    if (callback != null) {
      callback();
      return;
    }
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const LeaderboardPage()));
  }

  void _startQuiz() {
    final callback = widget.onStartQuizPressed;
    if (callback != null) {
      callback();
      return;
    }
    Navigator.of(context).maybePop();
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          "You'll need to sign in again to continue your learning journey.",
        ),
        actions: [
          TextButton(
            key: const ValueKey('profile.signOut.cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            key: const ValueKey('profile.signOut.confirm'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFD64545),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }

    final callback = widget.onSignOut;
    if (callback != null) {
      callback();
      return;
    }

    await AppSession.clear();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => SignInPage()),
      (route) => false,
    );
  }
}

/// The profile page's top card: avatar, name, email, join date, and the
/// user's live Leaderboard rank — styled as a navy "hero" card matching
/// Home's own hero banner, so Profile reads as the same product rather
/// than a bolted-on settings screen.
class _ProfileHeroCard extends StatelessWidget {
  const _ProfileHeroCard({
    required this.viewModel,
    required this.onEditPressed,
    required this.onRankPressed,
  });

  final ProfileViewModel viewModel;
  final VoidCallback onEditPressed;
  final VoidCallback onRankPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [HomePage.heroBackground, Color(0xFF0C1B2E)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: HomePage.heroBackground.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    key: const ValueKey('profile.avatar'),
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: HomePage.heroHighlight.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.7),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      viewModel.initials,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: HomePage.heroHighlight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: GestureDetector(
                      key: const ValueKey('profile.edit'),
                      onTap: onEditPressed,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: HomePage.heroHighlight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: HomePage.heroBackground,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 13,
                          color: HomePage.heroBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.fullName,
                        key: const ValueKey('profile.name'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (viewModel.email.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          viewModel.email,
                          key: const ValueKey('profile.email'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.72),
                          ),
                        ),
                      ],
                      if (viewModel.goal != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          key: const ValueKey('profile.goalChip'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _goalIcon(viewModel.goal!.icon),
                                size: 13,
                                color: HomePage.heroHighlight,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                viewModel.goal!.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (viewModel.memberSinceLabel != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          viewModel.memberSinceLabel!,
                          key: const ValueKey('profile.memberSince'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          InkWell(
            key: const ValueKey('profile.rankBadge'),
            onTap: onRankPressed,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    size: 18,
                    color: HomePage.heroHighlight,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Rank #${viewModel.leaderboardRank} on the '
                      'Leaderboard',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "My Statistics": the same three real, computed stats as before, now
/// grouped inside one titled card to match the rest of Profile's sections.
class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HomePage.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Statistics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: HomePage.heroBackground,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  key: const ValueKey('profile.stat.quizzes'),
                  icon: Icons.fact_check_outlined,
                  value: '${viewModel.quizzesCompleted}',
                  label: 'Quizzes\nCompleted',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  key: const ValueKey('profile.stat.average'),
                  icon: Icons.insights_outlined,
                  value: '${viewModel.averageScorePercent}%',
                  label: 'Average\nScore',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  key: const ValueKey('profile.stat.questions'),
                  icon: Icons.menu_book_outlined,
                  value: '${viewModel.questionsAnswered}',
                  label: 'Questions\nAnswered',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: HomePage.pageBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: HomePage.heroHighlight, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: HomePage.heroBackground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              height: 1.25,
              color: HomePage.supportText,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: HomePage.heroBackground,
        letterSpacing: -0.2,
      ),
    );
  }
}

IconData _goalIcon(GoalIconType type) => switch (type) {
  GoalIconType.scales => Icons.balance,
  GoalIconType.trophy => Icons.emoji_events_outlined,
  GoalIconType.graduationCap => Icons.school_outlined,
};

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.viewModel, required this.onChangePressed});

  final ProfileViewModel viewModel;
  final VoidCallback onChangePressed;

  @override
  Widget build(BuildContext context) {
    final goal = viewModel.goal;
    return Container(
      key: ValueKey(goal == null ? 'profile.goal.empty' : 'profile.goal.card'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: HomePage.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: HomePage.heroBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(
              goal == null ? Icons.flag_outlined : _goalIcon(goal.icon),
              color: HomePage.heroHighlight,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal?.title ?? 'No goal selected',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: HomePage.heroBackground,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  goal?.description ??
                      'Choose a goal to personalize your learning path.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: HomePage.supportText,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            key: ValueKey(
              goal == null ? 'profile.goal.choose' : 'profile.goal.change',
            ),
            onPressed: onChangePressed,
            style: TextButton.styleFrom(
              foregroundColor: HomePage.heroHighlight,
            ),
            child: Text(goal == null ? 'Choose' : 'Change'),
          ),
        ],
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity({
    required this.viewModel,
    required this.onStartQuizPressed,
  });

  final ProfileViewModel viewModel;
  final VoidCallback onStartQuizPressed;

  @override
  Widget build(BuildContext context) {
    final attempts = viewModel.recentAttempts;
    if (attempts.isEmpty) {
      return Container(
        key: const ValueKey('profile.activity.empty'),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: HomePage.cardBorder),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.history_toggle_off_rounded,
              size: 28,
              color: HomePage.mutedIcon,
            ),
            const SizedBox(height: 10),
            const Text(
              'No quizzes completed yet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: HomePage.heroBackground,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Finish a quiz to see your progress here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: HomePage.supportText),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              key: const ValueKey('profile.startQuiz'),
              onPressed: onStartQuizPressed,
              style: TextButton.styleFrom(
                foregroundColor: HomePage.heroHighlight,
                backgroundColor: HomePage.heroHighlight.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: const Text(
                'Start a Quiz',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final (index, attempt) in attempts.indexed) ...[
          _AttemptRow(index: index, attempt: attempt),
          if (index != attempts.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _AttemptRow extends StatelessWidget {
  const _AttemptRow({required this.index, required this.attempt});

  final int index;
  final QuizAttempt attempt;

  String get _scoreLabel =>
      '${attempt.correctCount}/${attempt.total} · '
      '${(attempt.scoreFraction * 100).round()}%';

  String get _dateLabel {
    final completedAt = attempt.completedAt;
    final now = DateTime.now();
    final difference = DateTime(now.year, now.month, now.day).difference(
      DateTime(completedAt.year, completedAt.month, completedAt.day),
    );
    final days = difference.inDays;
    if (days <= 0) {
      return 'Today';
    }
    if (days == 1) {
      return 'Yesterday';
    }
    if (days < 7) {
      return '$days days ago';
    }
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[completedAt.month - 1]} ${completedAt.day}';
  }

  Color get _scoreColor {
    final fraction = attempt.scoreFraction;
    if (fraction >= 0.8) return HomePage.easyColor;
    if (fraction >= 0.5) return HomePage.mediumColor;
    return HomePage.hardColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('profile.attempt.$index'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HomePage.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _scoreColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.quiz_outlined, color: _scoreColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attempt.topicTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: HomePage.heroBackground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _dateLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: HomePage.supportText,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _scoreLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _scoreColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// A titled white card holding a list of [_MenuRow]s, used for "My
/// Learning" and "Account" — Profile's menu-style sections.
class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.title, required this.rows});

  final String title;
  final List<_MenuRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: HomePage.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: HomePage.heroBackground,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < rows.length; i++) ...[
            if (i != 0) const Divider(height: 1, color: HomePage.cardBorder),
            rows[i],
          ],
        ],
      ),
    );
  }
}

/// One tappable row inside a [_MenuCard]: an icon, a title, a subtitle,
/// and a trailing chevron.
class _MenuRow extends StatelessWidget {
  const _MenuRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor = HomePage.heroHighlight,
    this.titleColor = HomePage.heroBackground,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color iconColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: HomePage.supportText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: HomePage.mutedIcon,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _EditProfileResult {
  const _EditProfileResult(this.fullName, this.email);

  final String fullName;
  final String email;
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({
    required this.initialFullName,
    required this.initialEmail,
  });

  final String initialFullName;
  final String initialEmail;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _fullNameController = TextEditingController(
    text: widget.initialFullName,
  );
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: HomePage.cardBorder),
    );
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: HomePage.mutedIcon),
      filled: true,
      fillColor: HomePage.pageBackground,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: HomePage.heroHighlight, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Text(
        'Edit Profile',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: HomePage.heroBackground,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const ValueKey('profile.editDialog.fullName'),
              controller: _fullNameController,
              decoration: _fieldDecoration(
                'Full Name',
                Icons.person_outline_rounded,
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return 'Full name is required';
                }
                if (trimmed.length < 3) {
                  return 'Name must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              key: const ValueKey('profile.editDialog.email'),
              controller: _emailController,
              decoration: _fieldDecoration(
                'Email Address',
                Icons.mail_outline_rounded,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (trimmed.isEmpty) {
                  return 'Email address is required';
                }
                if (!emailPattern.hasMatch(trimmed)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: [
        TextButton(
          key: const ValueKey('profile.editDialog.cancel'),
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: HomePage.supportText),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const ValueKey('profile.editDialog.save'),
          onPressed: () {
            if (_formKey.currentState?.validate() != true) {
              return;
            }
            Navigator.of(context).pop(
              _EditProfileResult(
                _fullNameController.text.trim(),
                _emailController.text.trim(),
              ),
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: HomePage.heroHighlight,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
