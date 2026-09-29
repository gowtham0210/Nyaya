import '../../quiz_question/data/quiz_api.dart';

/// One stop on the Leaderboard's quiz journey: either a quiz to play or a
/// chest to open. Kept as one class with a discriminating [isChest] flag
/// rather than a hierarchy, since the UI only ever branches on it once.
class JourneyStop {
  const JourneyStop.quiz({
    required this.quiz,
    required this.levelNumber,
    required this.isBossLevel,
    required this.isCompleted,
    required this.isLocked,
  }) : chestIndex = null,
       isChestOpened = false,
       isChestAvailable = false;

  const JourneyStop.chest({
    required int this.chestIndex,
    required this.isChestOpened,
    required this.isChestAvailable,
  }) : quiz = null,
       levelNumber = 0,
       isBossLevel = false,
       isCompleted = isChestOpened,
       isLocked = false;

  /// Set for a quiz stop, null for a chest stop.
  final RemoteQuiz? quiz;

  final int levelNumber;

  /// Every 5th level carries 10 quizzes instead of 5.
  final bool isBossLevel;

  final bool isCompleted;

  /// True once this stop is unlocked but not yet finished — locked until
  /// the previous stop is completed.
  final bool isLocked;

  /// Set for a chest stop, null for a quiz stop.
  final int? chestIndex;
  final bool isChestOpened;

  /// True once the level before this chest is fully finished and the chest
  /// hasn't been opened yet.
  final bool isChestAvailable;

  bool get isChest => chestIndex != null;
}

/// Builds the ordered stops for the Leaderboard's "Learning Journey": pool
/// quizzes laid out five to a level, ten on every fifth ("boss") level,
/// unlocked one stop at a time, with a chest after every finished cluster
/// of five levels.
class LeaderboardJourney {
  const LeaderboardJourney({required this.stops});

  final List<JourneyStop> stops;

  static const levelsPerCluster = 5;
  static const normalLevelSize = 5;
  static const bossLevelSize = 10;

  static LeaderboardJourney build({
    required List<RemoteQuiz> pool,
    required Set<String> completedSlugs,
    required Set<int> openedChests,
  }) {
    final stops = <JourneyStop>[];
    var index = 0;
    var levelNumber = 1;
    // The first stop on the whole journey is always unlocked.
    var previousCompleted = true;

    while (index < pool.length) {
      final isBoss = levelNumber % levelsPerCluster == 0;
      final size = isBoss ? bossLevelSize : normalLevelSize;
      final slice = pool.skip(index).take(size);
      var levelCompleted = true;

      for (final quiz in slice) {
        final completed = completedSlugs.contains(quiz.slug);
        levelCompleted = levelCompleted && completed;
        stops.add(
          JourneyStop.quiz(
            quiz: quiz,
            levelNumber: levelNumber,
            isBossLevel: isBoss,
            isCompleted: completed,
            isLocked: !previousCompleted,
          ),
        );
        previousCompleted = completed;
      }
      index += size;

      if (isBoss) {
        final chestIndex = (levelNumber ~/ levelsPerCluster) - 1;
        final opened = openedChests.contains(chestIndex);
        stops.add(
          JourneyStop.chest(
            chestIndex: chestIndex,
            isChestOpened: opened,
            isChestAvailable: levelCompleted && !opened,
          ),
        );
      }
      levelNumber++;
    }

    return LeaderboardJourney(stops: stops);
  }
}
