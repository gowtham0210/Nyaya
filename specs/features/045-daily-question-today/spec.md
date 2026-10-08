# 045-daily-question-today Today's Question, Graded by the Backend

Status: Implemented
Last Updated: 2026-10-06
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Supersedes: 043 (carousel of random questions with an answer-reveal
fallback) and 018's use of `/daily-questions/random`.
Backend: `nyaya_backend` 430886e "Make daily questions multiple choice and
gradeable".

## Problem

Home showed "Show answer": the learner saw the answer without trying. The
backend now serves one multiple-choice question per day and grades it.

## Goals

- One question a day with options; the learner picks, the backend grades.
- After answering: right/wrong, the correct option, the explanation and
  points earned; Home's points and streak update.
- Coming back the same day shows the answered result, not the question
  again.

## Non-Goals

- More than one question a day, so no carousel.
- Achievement pop-ups (the answer response lists them; not shown yet).

## Backend contract (as built)

- `GET /daily-questions/today` (`lang` added by the client) →
  `{ date, answered, question: { id, category, question, pointsReward,
  options: [{ id, optionText }] } | null, result }`.
- `result` is null until answered, then `{ selectedOptionId,
  correctOptionId, isCorrect, pointsEarned, explanation }`.
- `POST /daily-questions/today/answer { selectedOptionId }` → 201, same
  shape, plus `totalPoints`, `currentStreak`, `unlockedAchievements`.
  A second answer is 409.

## Decisions

- No question today (`question: null`) is the empty state.
- Picking sends the answer at once: the picked option shows a spinner and
  the others lock. On success the result replaces the question in place.
- A failed answer keeps the question open with a snackbar
  (`quizAnswerFailed`). A 409 (answered on another device) reloads today.
- After a graded answer, Home reloads progress and the profile (streak
  chip) through an `onAnswered` callback.
- Haptics as spec 039: select, then correct or wrong.
- Header chip: "+10 points" before answering; afterwards "+10 earned" or
  nothing for a wrong answer.

## Functional Requirements

- FR-001: Home shall load today's question with its options.
- FR-002: Picking an option shall post it once and show the graded result.
- FR-003: An answered day shall show the result on load.
- FR-004: A failed answer shall keep the question open; a 409 reloads.
- FR-005: A graded answer shall refresh Home's points and streak.
- FR-006: New strings in all five languages.

## Acceptance Criteria

- AC-001: The repository parses today (unanswered, answered, none) and
  posts `{selectedOptionId}`.
- AC-002: View model: answer → Loaded with result and `onAnswered` once;
  failure keeps the question and reports it; 409 reloads.
- AC-003: Page: options, no "Show answer"; right pick → green, "Correct!",
  explanation, "+10 earned"; wrong → red, right option marked, "Not quite".
- AC-004: An answered day shows the result with options locked.
- AC-005: No question shows the empty message; fits large text; Hindi.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/home/data/daily_questions_repository_test.dart` |
| AC-002 | Unit | `test/features/home/presentation/daily_questions_view_model_test.dart` |
| AC-003–AC-005 | Widget | `test/features/home/presentation/daily_questions_section_test.dart`, `learning_localization_test.dart` |
| On device | Manual | Needs the backend commit deployed and `db:seed-daily-questions` run on the hosted server |
