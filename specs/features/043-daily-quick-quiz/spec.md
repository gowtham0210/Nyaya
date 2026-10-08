# 043-daily-quick-quiz Daily Questions as a Swipeable Quick Quiz

Status: Superseded by 045 (the backend serves one graded question a day)
Last Updated: 2026-10-06
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Supersedes: 018's stacked list and answer reveal (owner request
2026-10-06).

## Problem

Daily Questions showed three stacked cards with a "Show answer" toggle:
reading, not practice, and a tall block on Home.

## Goals

- One question at a time in a swipeable carousel with page dots.
- Each question is a quick quiz: pick an option, see right or wrong, the
  right option, and the explanation.
- A score once all are answered.

## Non-Goals

- Saving answers, points or streaks (no backend endpoint).
- The backend change itself (owner: options will come from the backend).

## Decisions

- Planned backend contract for `GET /daily-questions/random` items, added
  to today's fields:
  - `options`: `[{ "id": 11, "optionText": "Article 21" }, …]` (2–4),
  - `correctOptionId`: `11`,
  - `answer`: kept, shown as the explanation.
  The key is checked in the app: these are unscored practice questions,
  so sending it is fine.
- An item without valid options (today's backend) falls back to a
  "Show answer" reveal inside the same card, so Home keeps working.
- Carousel: `PageView` at 92% width so the next card peeks; its height
  follows the current card, eased between cards while swiping. Dots below
  jump to a card. After answering, "Next question" slides on.
- Feedback reuses the quiz language: options ease to green/red, the right
  one is always marked, haptics as in spec 039 (select, then correct or
  wrong).
- Header chip: "1 of 3" while answering; "2/3 correct" once all quiz
  questions are answered.
- New data clears all picks and returns to the first card.

## Functional Requirements

- FR-001: Questions shall show one at a time, swipeable, with dots.
- FR-002: Tapping an option shall lock the question and show right/wrong,
  the right option and the explanation.
- FR-003: Questions without options shall offer Show/Hide answer.
- FR-004: Next shall move to the next card; the last card has none.
- FR-005: Once every quiz question is answered, the header shall show the
  score.
- FR-006: Loading, empty and failed states stay as in 018.
- FR-007: New strings in all five languages.

## Acceptance Criteria

- AC-001: The repository maps `options` and `correctOptionId`; items
  without them map with no options.
- AC-002: View model: one pick per question, correct/wrong, score, reload
  clears picks.
- AC-003: Right pick → green, "Correct!", explanation, light haptic; wrong
  pick → red, right option marked, "Not quite"; a second tap changes
  nothing.
- AC-004: Next and swiping change the card; dots show and set the page.
- AC-005: After all answers the chip shows "2/3 correct".
- AC-006: A question without options reveals its answer.
- AC-007: Fits a 360 px phone at 1.6× text; renders in Hindi.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/home/data/daily_questions_repository_test.dart` |
| AC-002 | Unit | `test/features/home/presentation/daily_questions_view_model_test.dart` |
| AC-003–AC-007 | Widget | `test/features/home/presentation/daily_questions_section_test.dart` |
| Feel on device | Manual | Pending: needs backend options |
