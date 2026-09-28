# 018-daily-questions Daily Questions on Home

Status: Implemented
Last Updated: 2026-09-28
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Source: GitHub issue #29 (parent #24). Ported from `nisha-frontend`
a62651c (`daily_questions_section.dart`, `daily_questions_api_service.dart`).

## Problem

Home has no quick daily practice, so learners have little reason to open
the app each day.

## Goals

- Home shows a few daily questions from the backend in the learner's
  language.
- The learner reveals each answer inline, in one tap. "Answer" in issue #29
  means reveal: the backend gives an answer text, not options.
- The section loads on its own and never blocks the rest of Home.

## Non-Goals

- Scoring or saving answers.
- Reloading when the language changes (done in spec 028, issue #35).
- Pull-to-refresh.

## Actors

- Signed-in learner on Home.

## Assumptions

- `GET /daily-questions/random?count=N` returns `{ items: DailyQuestion[] }`
  with `id`, `category`, `question`, `answer`, and requires a bearer token
  (shape from `nisha-frontend`).
- The backend picks random questions per request.

## Functional Requirements

- FR-001: When Home opens, the app shall request 3 daily questions in the
  current language and show a loading indicator in the section meanwhile.
  (`nisha-frontend` asked for 2; the issue asks for "a few".)
- FR-002: When questions load, the section shall show each question with its
  number and category, and the question count.
- FR-003: When the learner taps a question, the app shall show its answer
  below it; tapping again shall hide it.
- FR-004: When the backend returns no questions, the section shall show an
  empty message.
- FR-005: When loading fails, the section shall show the shared localized
  failure message; offline and other failures offer Retry, which reloads.
- FR-006: While the section is loading, empty or failed, the rest of Home
  shall render and work.
- FR-007: When an earlier load finishes after a later one, the app shall keep
  the later result.
- FR-008: When questions reload, all answers shall start hidden.

## Non-Functional Requirements

- NFR-001: Each question announces itself to screen readers as a button with
  its number, text and category, and whether its answer is shown.

## UX Notes

- Placed after Continue Learning, before Popular Quizzes.
- Card with lightbulb badge, title, subtitle and count chip.
- Question tiles: numbered badge, question, category chip, Show/Hide answer
  toggle; the answer sits in a panel with an accent left border.
- Loading, empty and error reuse the shared `LoadStateView`.

## Data and Integration Impact

- Remote APIs: `GET /daily-questions/random`, with `count`, plus `lang` for
  non-English languages.

## Acceptance Criteria

- AC-001: The repository requests `count=3` with the current language and
  maps each item to a plain model.
- AC-002: The view model moves loading → loaded, loading → empty, and
  loading → error (including an unreadable response); `load()` again
  recovers; the latest overlapping load wins.
- AC-003: Toggling a question reveals then hides its answer; a reload hides
  all answers.
- AC-004: Home shows the section with each question, its category and the
  count; answers are hidden until tapped.
- AC-005: Tapping a question shows its answer; tapping again hides it.
- AC-006: Offline shows the offline message with Retry; Retry loads the
  questions. No questions shows the empty message.
- AC-007: While the section is loading or failed, the Home hero and
  categories still render.
- AC-008: Each question is a button whose semantics give its number, text,
  category and expanded state.
- AC-009: The section renders in Hindi.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/home/data/daily_questions_repository_test.dart` |
| AC-002, AC-003 | Unit | `test/features/home/presentation/daily_questions_view_model_test.dart` |
| AC-004–AC-008 | Widget | `test/features/home/presentation/daily_questions_section_test.dart` |
| AC-009 | Widget | `test/features/learning_localization_test.dart` |

## Open Questions

- The local backend checkout has no `/daily-questions` route; confirm the
  shape with the backend owner.
- Should a revealed answer count toward the learner's streak?
