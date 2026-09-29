import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/leaderboard/presentation/leaderboard_journey.dart';
import 'package:nyaya/features/quiz_question/data/quiz_api.dart';

void main() {
  List<RemoteQuiz> pool(int count) => [
    for (var i = 1; i <= count; i++)
      RemoteQuiz(id: i, slug: 'quiz-$i', title: 'Quiz $i', totalQuestions: 5),
  ];

  test('lays out normal levels at 5 quizzes and every 5th level at 10', () {
    // Cycle 1: levels 1-4 at 5 each (20), level 5 (boss) at 10 = 30 quizzes,
    // then a chest.
    final journey = LeaderboardJourney.build(
      pool: pool(30),
      completedSlugs: const {},
      openedChests: const {},
    );

    final quizStops = journey.stops.where((stop) => !stop.isChest).toList();
    expect(quizStops, hasLength(30));

    final levelSizes = <int, int>{};
    for (final stop in quizStops) {
      levelSizes.update(
        stop.levelNumber,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    expect(levelSizes, {1: 5, 2: 5, 3: 5, 4: 5, 5: 10});
    expect(quizStops.where((s) => s.isBossLevel).length, 10);
    expect(
      quizStops.where((s) => s.levelNumber == 5).every((s) => s.isBossLevel),
      isTrue,
    );
  });

  test('places exactly one chest after a finished cluster of 5 levels', () {
    final journey = LeaderboardJourney.build(
      pool: pool(30),
      completedSlugs: const {},
      openedChests: const {},
    );

    final chests = journey.stops.where((stop) => stop.isChest).toList();
    expect(chests, hasLength(1));
    expect(journey.stops.last.isChest, isTrue);
    expect(chests.single.chestIndex, 0);
  });

  test(
    'the first quiz is always unlocked; the rest wait on the one before them',
    () {
      final journey = LeaderboardJourney.build(
        pool: pool(3),
        completedSlugs: const {},
        openedChests: const {},
      );
      final quizStops = journey.stops.where((stop) => !stop.isChest).toList();

      expect(quizStops[0].isLocked, isFalse);
      expect(quizStops[1].isLocked, isTrue);
      expect(quizStops[2].isLocked, isTrue);
    },
  );

  test('finishing a quiz unlocks the next one', () {
    final journey = LeaderboardJourney.build(
      pool: pool(3),
      completedSlugs: {'quiz-1'},
      openedChests: const {},
    );
    final quizStops = journey.stops.where((stop) => !stop.isChest).toList();

    expect(quizStops[0].isCompleted, isTrue);
    expect(quizStops[1].isLocked, isFalse);
    expect(quizStops[2].isLocked, isTrue);
  });

  test('a chest is unavailable until every quiz in its boss level is done', () {
    final completeExceptLast = {for (var i = 1; i < 30; i++) 'quiz-$i'};
    final almostDone = LeaderboardJourney.build(
      pool: pool(30),
      completedSlugs: completeExceptLast,
      openedChests: const {},
    );
    expect(almostDone.stops.last.isChestAvailable, isFalse);

    final allDone = LeaderboardJourney.build(
      pool: pool(30),
      completedSlugs: {for (var i = 1; i <= 30; i++) 'quiz-$i'},
      openedChests: const {},
    );
    expect(allDone.stops.last.isChestAvailable, isTrue);
  });

  test('an opened chest is never reported as available again', () {
    final journey = LeaderboardJourney.build(
      pool: pool(30),
      completedSlugs: {for (var i = 1; i <= 30; i++) 'quiz-$i'},
      openedChests: const {0},
    );

    expect(journey.stops.last.isChestOpened, isTrue);
    expect(journey.stops.last.isChestAvailable, isFalse);
  });

  test('an empty pool produces an empty journey', () {
    final journey = LeaderboardJourney.build(
      pool: const [],
      completedSlugs: const {},
      openedChests: const {},
    );

    expect(journey.stops, isEmpty);
  });
}
