import 'package:flutter/foundation.dart';

import 'api_client.dart';

/// The Leaderboard journey's spendable currency and progress.
///
/// Entering a pool quiz costs [quizCost] credits; opening a chest awards
/// [chestReward]; the balance drifts back up by [regenAmount] every
/// [regenInterval] until it hits [maxCredits] — the same "energy" shape as
/// Duolingo hearts, so working through the journey doesn't require paying
/// real money or grinding without a break.
///
/// Every balance change is server-authoritative: this store is a cache of
/// what `/credits` last said, refreshed after each mutation, never a ledger
/// of its own. A device can display a stale number while offline, but it
/// can't hand itself credits — every spend, refund, penalty, reward and
/// chest claim round-trips through the backend, which is the only thing
/// that ever writes the real balance.
class LeaderboardProgressStore {
  LeaderboardProgressStore._();

  static const quizCost = 25;
  static const chestReward = 40;

  /// Taken for every wrong answer inside a quiz, on top of the entry cost.
  static const wrongAnswerPenalty = 5;

  /// Credits earned by watching a rewarded ad.
  static const adReward = 25;

  /// Credits from a chest on the level journey, which sits after every
  /// [levelsPerChest] levels.
  static const levelChestReward = 10;
  static const levelsPerChest = 4;
  static const regenAmount = 20;
  static const regenInterval = Duration(hours: 5);
  static const maxCredits = 100;

  static int credits = maxCredits;

  /// Mirrors [credits] for widgets that stay on screen while the balance
  /// changes elsewhere — e.g. the Quizzes tab while a quiz is played on top.
  static final ValueNotifier<int> creditsNotifier = ValueNotifier(maxCredits);
  static DateTime? _nextRegenAt;

  /// Chest indices the backend has confirmed as claimed, synced by
  /// [refreshRegen]. Read-only from here — a claim only ever gets added
  /// after the server pays it out.
  static Set<int> openedChests = {};
  static Set<int> openedLevelChests = {};

  /// The id of the most recent successful spend, so a matching [refund]
  /// hands back exactly what the server took — never an amount the client
  /// invents. Cleared once used or once a call to [spend] replaces it.
  static int? _pendingSpendTransactionId;

  /// Swapped out in tests to point at a fake backend instead of the real
  /// one; production code never calls this.
  @visibleForTesting
  static ApiClient Function() clientFactory = ApiClient.new;

  /// Time left before the next credit trickles in, or null while already at
  /// the cap (or the balance hasn't been fetched yet).
  static Duration? get timeUntilNextRegen {
    final next = _nextRegenAt;
    if (next == null) {
      return null;
    }
    final remaining = next.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  static Future<void> load() => refreshRegen();

  /// Re-syncs the balance and claimed chests against the backend. A network
  /// failure leaves whatever was last known in place rather than resetting
  /// it, so a flaky connection doesn't wipe the UI mid-session.
  static Future<void> refreshRegen() async {
    final api = clientFactory();
    try {
      _applySnapshot(await api.get('/credits'));
    } on ApiException {
      // Keep the last-known balance.
    }
    try {
      final json = await api.get('/credits/chests/pool');
      openedChests = _intSet(json);
    } on ApiException {
      // Keep the last-known set.
    }
    try {
      final json = await api.get('/credits/chests/level');
      openedLevelChests = _intSet(json);
    } on ApiException {
      // Keep the last-known set.
    }
  }

  static Set<int> _intSet(Map<String, Object?> json) => {
    for (final value in json['items'] as List<Object?>) (value as num).toInt(),
  };

  static void _applySnapshot(Map<String, Object?> json) {
    credits = (json['credits'] as num).toInt();
    creditsNotifier.value = credits;
    final nextRegenAt = json['nextRegenAt'] as String?;
    _nextRegenAt = nextRegenAt == null ? null : DateTime.tryParse(nextRegenAt);
  }

  /// Spends the quiz entry cost, server-side. Returns whether there was
  /// enough balance; a network failure fails closed (returns false) rather
  /// than letting a quiz start on a balance nobody checked.
  static Future<bool> spend(int amount) async {
    assert(
      amount == quizCost,
      'the backend only knows a fixed quiz-entry cost',
    );
    try {
      final json = await clientFactory().post('/credits/spend', {
        'reason': 'quiz_entry',
      });
      _applySnapshot(json);
      final success = json['success'] == true;
      _pendingSpendTransactionId = success
          ? (json['transactionId'] as num?)?.toInt()
          : null;
      return success;
    } on ApiException {
      return false;
    }
  }

  /// Refunds the most recent [spend] — exactly what the server took for it,
  /// never [amount] itself, and never twice: the backend rejects a repeat
  /// refund of the same spend.
  static Future<void> refund(int amount) async {
    final transactionId = _pendingSpendTransactionId;
    if (transactionId == null) {
      return;
    }
    _pendingSpendTransactionId = null;
    try {
      _applySnapshot(
        await clientFactory().post('/credits/$transactionId/refund', const {}),
      );
    } on ApiException {
      // Best effort — the server keeps the record of the spend either way.
    }
  }

  static bool isChestOpened(int chestIndex) =>
      openedChests.contains(chestIndex);

  static bool isLevelChestOpened(int chestIndex) =>
      openedLevelChests.contains(chestIndex);

  /// Docks [wrongAnswerPenalty] server-side, floored at zero.
  static Future<void> penaliseWrongAnswer() async {
    try {
      _applySnapshot(await clientFactory().post('/credits/penalty', const {}));
    } on ApiException {
      // Offline: nothing to dock yet: the next [refreshRegen] catches up.
    }
  }

  /// Pays [adReward] for a watched ad, up to the cap. The backend rate-limits
  /// this — see the `ponytail:` note on its `rewardAd` for why a real ad
  /// network's server-side verification is still the right next step.
  static Future<void> rewardForAd() async {
    try {
      _applySnapshot(await clientFactory().post('/credits/ad-reward', const {}));
    } on ApiException {
      // Cooldown or offline: no reward this time.
    }
  }

  /// Claims a level-journey chest. The backend is the one that checks
  /// readiness and rejects a repeat claim — this just reports what it said.
  static Future<bool> openLevelChest(int chestIndex) =>
      _claimChest('level', chestIndex, openedLevelChests);

  /// Claims a pool-journey chest; see [openLevelChest].
  static Future<bool> openChest(int chestIndex) =>
      _claimChest('pool', chestIndex, openedChests);

  static Future<bool> _claimChest(
    String chestType,
    int chestIndex,
    Set<int> localCache,
  ) async {
    try {
      final json = await clientFactory().post(
        '/credits/chests/$chestType/$chestIndex/claim',
        const {},
      );
      _applySnapshot(json);
      final success = json['success'] == true;
      if (success) {
        localCache.add(chestIndex);
      }
      return success;
    } on ApiException {
      return false;
    }
  }

  /// Test-only reset back to a fresh install's state.
  static Future<void> clear() async {
    credits = maxCredits;
    creditsNotifier.value = credits;
    _nextRegenAt = null;
    openedChests = {};
    openedLevelChests = {};
    _pendingSpendTransactionId = null;
  }
}
