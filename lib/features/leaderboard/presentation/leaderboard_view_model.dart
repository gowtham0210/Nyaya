import 'package:flutter/material.dart';

import '../../../app/app_session.dart';
import '../../../app/quiz_history_store.dart';
import '../../../app/user_api.dart';
import '../../../app/user_stats_store.dart';

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.points,
    required this.avatarColor,
    required this.isCurrentUser,
  });

  final int rank;
  final String name;
  final int points;
  final Color avatarColor;
  final bool isCurrentUser;

  static const pointsPerLevel = 300;

  /// Derived from points, since the backend has no level of its own: one
  /// level per [pointsPerLevel] points — roughly one well-played quiz.
  int get level => 1 + points ~/ pointsPerLevel;

  /// e.g. "Priya Sharma" -> "PS".
  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _RawEntry {
  const _RawEntry(this.name, this.points, this.isCurrentUser);

  final String name;
  final int points;
  final bool isCurrentUser;
}

/// Read model for the Leaderboard tab: learners ranked by points, with the
/// signed-in user's row highlighted.
///
/// Given a [stats] snapshot this is the real, server-computed ranking across
/// every user. Without one — signed out, or the server unreachable — it
/// falls back to an illustrative sample list with the user's own locally
/// stored score merged in, so the screen is never blank.
class LeaderboardViewModel {
  LeaderboardViewModel({
    String? currentUserName,
    List<QuizAttempt>? attempts,
    UserStats? stats,
  }) : _currentUserName = _cleanName(currentUserName ?? AppSession.fullName),
       _attempts = attempts ?? QuizHistoryStore.attempts,
       _stats = stats;

  static String _cleanName(String? raw) {
    final trimmed = raw?.trim() ?? '';
    return trimmed.isEmpty ? 'You' : trimmed;
  }

  final String _currentUserName;
  final List<QuizAttempt> _attempts;
  final UserStats? _stats;

  /// True when the ranking came from the backend rather than the sample
  /// list, so the screen can say which it is showing.
  bool get isLive => _stats != null;

  /// The signed-in user's id, for picking their row out of a period board
  /// fetched separately (weekly/monthly) — null while signed out or before
  /// live stats have loaded.
  int? get currentUserId => _stats?.currentUserId;

  int get _currentUserPoints {
    final correct = _attempts.fold<int>(
      0,
      (sum, attempt) => sum + attempt.correctCount,
    );
    return correct * 20 + _attempts.length * 30;
  }

  static const _avatarPalette = [
    Color(0xFFE07A5F),
    Color(0xFF81B29A),
    Color(0xFFF2CC8F),
    Color(0xFF6D8CC7),
    Color(0xFF9B5DE5),
    Color(0xFFEF6F6C),
    Color(0xFF2EC4B6),
    Color(0xFFEEB868),
    Color(0xFF7D8CA3),
    Color(0xFFC97BAE),
  ];

  static const _sampleEntries = [
    _RawEntry('Ananya Iyer', 1260, false),
    _RawEntry('Rohan Mehta', 1180, false),
    _RawEntry('Kabir Anand', 1170, false),
    _RawEntry('Devika Rao', 1010, false),
    _RawEntry('Sana Sheikh', 980, false),
    _RawEntry('Meera Krishnan', 910, false),
    _RawEntry('Ishaan Verma', 850, false),
    _RawEntry('Farhan Ali', 810, false),
    _RawEntry('Priyansh Gupta', 770, false),
  ];

  /// Full ranking, highest points first.
  List<LeaderboardEntry> get entries {
    final stats = _stats;
    if (stats != null) {
      // The server already ranked these, so its order and rank numbers are
      // taken as given rather than recomputed.
      return [
        for (final (index, entry) in stats.leaderboard.indexed)
          LeaderboardEntry(
            rank: entry.rank,
            name: entry.fullName,
            points: entry.totalPoints,
            avatarColor: _avatarPalette[index % _avatarPalette.length],
            isCurrentUser: entry.userId == stats.currentUserId,
          ),
      ];
    }

    final raw = [
      ..._sampleEntries,
      _RawEntry(_currentUserName, _currentUserPoints, true),
    ]..sort((a, b) => b.points.compareTo(a.points));

    return [
      for (final (index, entry) in raw.indexed)
        LeaderboardEntry(
          rank: index + 1,
          name: entry.name,
          points: entry.points,
          avatarColor: _avatarPalette[index % _avatarPalette.length],
          isCurrentUser: entry.isCurrentUser,
        ),
    ];
  }

  /// Ranks 1-3, for the podium.
  ///
  /// Empty until three learners exist to fill it — a real ranking starts
  /// small, and half a podium reads as a broken layout rather than a
  /// standing.
  List<LeaderboardEntry> get podium =>
      entries.length >= 3 ? entries.take(3).toList() : const [];

  /// Everyone the podium doesn't already show: ranks 4 and below normally,
  /// or the whole ranking while it is too short for a podium.
  List<LeaderboardEntry> get remaining =>
      entries.length >= 3 ? entries.skip(3).toList() : entries;

  /// Builds display entries from a period board (weekly/monthly), fetched
  /// separately from the all-time [entries] above — same server ranking and
  /// rank numbers taken as given, same avatar palette so the two boards
  /// read as one design.
  static List<LeaderboardEntry> entriesFromRemote(
    List<RemoteLeaderboardEntry> remote,
    int? currentUserId,
  ) => [
    for (final (index, entry) in remote.indexed)
      LeaderboardEntry(
        rank: entry.rank,
        name: entry.fullName,
        points: entry.totalPoints,
        avatarColor: _avatarPalette[index % _avatarPalette.length],
        isCurrentUser: entry.userId == currentUserId,
      ),
  ];
}
