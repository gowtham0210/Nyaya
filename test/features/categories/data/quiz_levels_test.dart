import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/categories/data/quiz_levels.dart';
import 'package:nyaya/features/quiz_question/data/quiz_api.dart';

RemoteQuiz levelQuiz(int n, {int? questions, String difficulty = 'easy'}) =>
    RemoteQuiz(
      id: 100 + n,
      slug: 'legal-awareness-level-$n',
      title: 'Level $n',
      totalQuestions: questions ?? (n % 5 == 0 ? 10 : 5),
      difficulty: difficulty,
    );

RemoteAttempt attempt(int quizId, String status, {int answered = 0}) =>
    RemoteAttempt(
      id: quizId * 10,
      quizId: quizId,
      status: status,
      totalQuestions: 5,
      answeredQuestions: answered,
      correctAnswers: answered,
    );

void main() {
  // The backend lists a category's quizzes newest first, which is not level
  // order — build from a shuffled list to prove the sort.
  final shuffled = [
    for (final n in [3, 10, 1, 7, 5, 2, 9, 4, 8, 6]) levelQuiz(n),
  ];

  test('orders levels numerically, not alphabetically or by API order', () {
    final levels = buildQuizLevels(shuffled, const []);

    expect(levels.map((l) => l.number), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  });

  test('levels 5 and 10 are milestones; the rest are regular', () {
    final levels = buildQuizLevels(shuffled, const []);

    expect(
      [
        for (final l in levels)
          if (l.isMilestone) l.number,
      ],
      [5, 10],
    );
    expect(levels[4].milestoneLabel, 'Checkpoint Challenge');
    expect(levels[9].milestoneLabel, 'Final Challenge');
    expect(levels[0].milestoneLabel, isNull);
    expect(
      [for (final l in levels) l.quiz.totalQuestions],
      [5, 5, 5, 5, 10, 5, 5, 5, 5, 10],
    );
  });

  test('skips quizzes that are not levels', () {
    final levels = buildQuizLevels([
      levelQuiz(2),
      const RemoteQuiz(
        id: 1,
        slug: 'constitutional-law-quiz',
        title: 'Constitutional Law Quiz',
        totalQuestions: 10,
      ),
      levelQuiz(1),
    ], const []);

    expect(levels.map((l) => l.number), [1, 2]);
  });

  test('progress comes from the attempts: completed, resumable, fresh', () {
    final levels = buildQuizLevels(shuffled, [
      // Newest first: level 2 re-opened after an earlier submit.
      attempt(102, 'in_progress', answered: 2),
      attempt(102, 'submitted', answered: 5),
      attempt(101, 'submitted', answered: 5),
    ]);

    expect(levels[0].isCompleted, isTrue);
    expect(levels[0].canResume, isFalse);
    expect(levels[1].isCompleted, isTrue);
    expect(levels[1].canResume, isTrue);
    expect(levels[2].isCompleted, isFalse);
    expect(levels[2].latestAttempt, isNull);
  });

  test('difficulty labels come from the backend difficulty', () {
    final levels = buildQuizLevels([
      levelQuiz(1),
      levelQuiz(5, difficulty: 'medium'),
      levelQuiz(8, difficulty: 'medium'),
      levelQuiz(10, difficulty: 'hard'),
    ], const []);

    expect(levels.map((l) => l.difficultyLabel), [
      'Beginner',
      'Mixed Difficulty',
      'Intermediate',
      'Advanced',
    ]);
  });

  test('levels unlock one at a time as the previous is completed', () {
    // Nothing played yet: only Level 1 is open.
    final fresh = buildQuizLevels(shuffled, const []);
    expect(fresh[0].isLocked, isFalse);
    expect(fresh[1].isLocked, isTrue);
    expect(fresh[1].unlockHint, 'Finish Level 1 first.');
    expect(fresh[9].isLocked, isTrue);

    // Level 1 submitted: Level 2 opens, Level 3 still waits.
    final afterOne = buildQuizLevels(shuffled, [
      attempt(101, 'submitted', answered: 5),
    ]);
    expect(afterOne[0].isLocked, isFalse);
    expect(afterOne[1].isLocked, isFalse);
    expect(afterOne[2].isLocked, isTrue);
    expect(afterOne[2].unlockHint, 'Finish Level 2 first.');

    // An unfinished attempt is not a completion, so it unlocks nothing.
    final inProgress = buildQuizLevels(shuffled, [
      attempt(101, 'in_progress', answered: 3),
    ]);
    expect(inProgress[1].isLocked, isTrue);
  });

  test('the backend points gate applies once the journey reaches it', () {
    final levels = buildQuizLevels(
      [
        levelQuiz(1),
        const RemoteQuiz(
          id: 106,
          slug: 'legal-awareness-level-6',
          title: 'Level 6',
          totalQuestions: 5,
          difficulty: 'easy',
          levelId: 2,
          isLocked: true,
          requiredPoints: 250,
        ),
      ],
      // Level 1 is done, so only the points gate is left holding Level 6.
      [attempt(101, 'submitted', answered: 5)],
      {2: 'Apprentice'},
    );

    expect(levels[0].isLocked, isFalse);
    expect(levels[1].isLocked, isTrue);
    expect(levels[1].unlockHint, 'Reach 250 points (Apprentice) to unlock.');
  });
}
