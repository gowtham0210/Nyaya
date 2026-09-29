import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/app/api_client.dart';
import 'package:nyaya/app/leaderboard_progress_store.dart';

/// A minimal in-memory stand-in for the backend's `/credits` endpoints —
/// enough to prove the store defers every mutation to the server rather
/// than computing balances itself, which is the whole point of the fix.
class FakeCreditsBackend {
  int credits = LeaderboardProgressStore.maxCredits;
  int _nextTransactionId = 1;
  final Map<int, int> _spends = {}; // transactionId -> amount, unrefunded
  final Set<String> _claimedChests = {}; // 'type/index'
  bool chestsReady = true;

  http.Response _json(Object body, [int status = 200]) => http.Response(
    jsonEncode(body),
    status,
    headers: {'content-type': 'application/json'},
  );

  Map<String, Object?> get _snapshot => {
    'credits': credits,
    'maxCredits': LeaderboardProgressStore.maxCredits,
    'nextRegenAt': null,
  };

  Future<http.Response> handle(http.Request request) async {
    final path = request.url.path.replaceFirst('/api/v1', '');

    if (request.method == 'GET' && path == '/credits') {
      return _json(_snapshot);
    }
    if (request.method == 'GET' && path == '/credits/chests/pool') {
      return _json({
        'items': _claimedChests
            .where((key) => key.startsWith('pool/'))
            .map((key) => int.parse(key.split('/')[1]))
            .toList(),
      });
    }
    if (request.method == 'GET' && path == '/credits/chests/level') {
      return _json({
        'items': _claimedChests
            .where((key) => key.startsWith('level/'))
            .map((key) => int.parse(key.split('/')[1]))
            .toList(),
      });
    }
    if (request.method == 'POST' && path == '/credits/spend') {
      const cost = LeaderboardProgressStore.quizCost;
      if (credits < cost) {
        return _json({'success': false, ..._snapshot});
      }
      credits -= cost;
      final id = _nextTransactionId++;
      _spends[id] = cost;
      return _json({'success': true, 'transactionId': id, ..._snapshot});
    }
    final refundMatch = RegExp(r'^/credits/(\d+)/refund$').firstMatch(path);
    if (request.method == 'POST' && refundMatch != null) {
      final id = int.parse(refundMatch.group(1)!);
      final amount = _spends.remove(id);
      if (amount == null) {
        return _json({'message': 'already refunded'}, 409);
      }
      credits = (credits + amount).clamp(0, LeaderboardProgressStore.maxCredits);
      return _json(_snapshot);
    }
    if (request.method == 'POST' && path == '/credits/penalty') {
      credits = (credits - LeaderboardProgressStore.wrongAnswerPenalty).clamp(
        0,
        LeaderboardProgressStore.maxCredits,
      );
      return _json(_snapshot);
    }
    if (request.method == 'POST' && path == '/credits/ad-reward') {
      credits = (credits + LeaderboardProgressStore.adReward).clamp(
        0,
        LeaderboardProgressStore.maxCredits,
      );
      return _json(_snapshot);
    }
    final claimMatch = RegExp(
      r'^/credits/chests/(pool|level)/(\d+)/claim$',
    ).firstMatch(path);
    if (request.method == 'POST' && claimMatch != null) {
      final type = claimMatch.group(1)!;
      final index = claimMatch.group(2)!;
      final key = '$type/$index';
      if (_claimedChests.contains(key)) {
        return _json({'success': false, 'alreadyClaimed': true, ..._snapshot});
      }
      if (!chestsReady) {
        return _json({'success': false, 'notReady': true, ..._snapshot});
      }
      _claimedChests.add(key);
      final reward = type == 'level'
          ? LeaderboardProgressStore.levelChestReward
          : LeaderboardProgressStore.chestReward;
      credits = (credits + reward).clamp(0, LeaderboardProgressStore.maxCredits);
      return _json({'success': true, ..._snapshot});
    }

    return _json({'message': 'not found'}, 404);
  }
}

void main() {
  late FakeCreditsBackend backend;

  setUp(() async {
    backend = FakeCreditsBackend();
    LeaderboardProgressStore.clientFactory = () => ApiClient(
      httpClient: MockClient(backend.handle),
    );
    await LeaderboardProgressStore.clear();
  });

  tearDown(() {
    LeaderboardProgressStore.clientFactory = ApiClient.new;
  });

  test('starts a fresh install at the max balance', () {
    expect(
      LeaderboardProgressStore.credits,
      LeaderboardProgressStore.maxCredits,
    );
  });

  test('spend deducts the quiz cost when there is enough balance', () async {
    final spent = await LeaderboardProgressStore.spend(
      LeaderboardProgressStore.quizCost,
    );

    expect(spent, isTrue);
    expect(
      LeaderboardProgressStore.credits,
      LeaderboardProgressStore.maxCredits - LeaderboardProgressStore.quizCost,
    );
  });

  test(
    'spend fails and leaves the balance untouched when it is too low',
    () async {
      while (LeaderboardProgressStore.credits >=
          LeaderboardProgressStore.quizCost) {
        await LeaderboardProgressStore.spend(LeaderboardProgressStore.quizCost);
      }
      final before = LeaderboardProgressStore.credits;

      final spent = await LeaderboardProgressStore.spend(
        LeaderboardProgressStore.quizCost,
      );

      expect(spent, isFalse);
      expect(LeaderboardProgressStore.credits, before);
    },
  );

  test(
    'a spend can be refunded exactly once — replaying it does not pay out '
    'twice',
    () async {
      await LeaderboardProgressStore.spend(LeaderboardProgressStore.quizCost);
      expect(
        LeaderboardProgressStore.credits,
        LeaderboardProgressStore.maxCredits - LeaderboardProgressStore.quizCost,
      );

      await LeaderboardProgressStore.refund(LeaderboardProgressStore.quizCost);
      expect(
        LeaderboardProgressStore.credits,
        LeaderboardProgressStore.maxCredits,
      );

      // The loophole this closes: calling refund again — with nothing left
      // to refund — must not hand out free credits.
      await LeaderboardProgressStore.refund(LeaderboardProgressStore.quizCost);
      expect(
        LeaderboardProgressStore.credits,
        LeaderboardProgressStore.maxCredits,
      );
    },
  );

  test('opening a chest awards the reward exactly once', () async {
    while (LeaderboardProgressStore.credits > 0) {
      await LeaderboardProgressStore.spend(LeaderboardProgressStore.quizCost);
    }
    expect(LeaderboardProgressStore.credits, 0);

    final firstOpen = await LeaderboardProgressStore.openChest(0);
    expect(firstOpen, isTrue);
    expect(
      LeaderboardProgressStore.credits,
      LeaderboardProgressStore.chestReward,
    );
    expect(LeaderboardProgressStore.isChestOpened(0), isTrue);

    // The loophole this closes: tapping the same chest again — say, by
    // replaying the request — must not pay out twice.
    final secondOpen = await LeaderboardProgressStore.openChest(0);
    expect(secondOpen, isFalse);
    expect(
      LeaderboardProgressStore.credits,
      LeaderboardProgressStore.chestReward,
    );
  });

  test('a chest not yet ready on the backend is refused, not paid', () async {
    backend.chestsReady = false;

    final opened = await LeaderboardProgressStore.openLevelChest(0);

    expect(opened, isFalse);
    expect(LeaderboardProgressStore.isLevelChestOpened(0), isFalse);
  });

  test('refreshRegen syncs the balance and claimed chests from the backend', () async {
    backend.credits = 55;
    await LeaderboardProgressStore.openLevelChest(0); // claimed server-side

    await LeaderboardProgressStore.clear(); // wipe the local cache
    await LeaderboardProgressStore.refreshRegen();

    expect(LeaderboardProgressStore.credits, backend.credits);
    expect(LeaderboardProgressStore.isLevelChestOpened(0), isTrue);
  });

  test('a wrong answer costs credits, but never below zero', () async {
    await LeaderboardProgressStore.spend(LeaderboardProgressStore.quizCost);
    final start = LeaderboardProgressStore.credits;

    await LeaderboardProgressStore.penaliseWrongAnswer();
    expect(
      LeaderboardProgressStore.credits,
      start - LeaderboardProgressStore.wrongAnswerPenalty,
    );

    while (LeaderboardProgressStore.credits > 0) {
      await LeaderboardProgressStore.penaliseWrongAnswer();
    }
    await LeaderboardProgressStore.penaliseWrongAnswer();
    expect(LeaderboardProgressStore.credits, 0);
  });

  test('watching an ad pays credits, capped at the maximum', () async {
    await LeaderboardProgressStore.spend(LeaderboardProgressStore.quizCost);
    final start = LeaderboardProgressStore.credits;

    await LeaderboardProgressStore.rewardForAd();
    expect(
      LeaderboardProgressStore.credits,
      start + LeaderboardProgressStore.adReward,
    );

    await LeaderboardProgressStore.rewardForAd();
    expect(
      LeaderboardProgressStore.credits,
      LeaderboardProgressStore.maxCredits,
    );
  });
}
