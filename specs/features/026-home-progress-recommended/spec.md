# 026-home-progress-recommended Learning Progress, Ask Nyaya and Recommended

Status: Implemented
Last Updated: 2026-09-28
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Source: GitHub issue #31 (parent #24). Ported from `nisha-frontend`
(`learning_progress_card`, `ask_nyaya_card`, `recommended_for_you_section`,
`all_recommended_screen`). Extends `../008-home-page/spec.md`.

## Problem

Home's Continue Learning card shows sample progress. Learners can't see
where to ask legal questions, or which categories to try next.

## Goals

- Continue Learning shows the learner's real progress.
- An Ask Nyaya card says the feature is coming soon.
- A Recommended section shows backend categories, with a see-all grid.

## Non-Goals

- Ask Nyaya itself.
- Personalised recommendations (the backend has none; we show categories).
- Resuming a specific quiz (Resume keeps today's provisional wire).
- Home's sample category strip and Popular Quizzes.

## Actors

- Learner on Home.

## Assumptions

- `GET /users/me/progress` returns `totalQuizzesAttempted`,
  `totalQuizzesCompleted`, `totalPoints` and `accuracyPercentage` (0–100).
- Recommended reuses the Categories tab's data (spec 017): same request,
  same view model.

## Functional Requirements

- FR-001: When Home opens, the app shall load the learner's progress and
  show a loading indicator in the Continue Learning card meanwhile.
- FR-002: The card shall show accuracy as a ring, quizzes completed, points,
  and a bar of completed ÷ attempted quizzes, with Resume.
- FR-003: When the learner has attempted no quizzes, the card shall show a
  "take your first quiz" message.
- FR-004: When progress fails to load, the card shall show the shared
  failure message with Retry.
- FR-005: Home shall show an Ask Nyaya card with a "Soon" badge; tapping it
  shall show a coming-soon message.
- FR-006: Home shall show a Recommended section: a horizontal strip of
  categories with quiz counts, and loading, empty and error-with-Retry
  states.
- FR-007: When the learner taps "View All", the app shall open a grid of all
  recommended categories.
- FR-008: Tapping a recommended category shall report it (default: a
  coming-soon message, like Home's other placeholders).
- FR-009: A failure in any section shall not block the rest of Home.

## Non-Functional Requirements

- NFR-001: Home, the see-all grid and the Categories tab share one
  categories view model, loaded once (`ensureLoaded`); Retry reloads.
- NFR-002: The progress card fits a 360 px phone.
- NFR-003: The progress view model extends a new core `LoadStateNotifier`
  (load state, latest-load-wins, safe dispose). Older view models copy that
  logic and can move to it later.

## Data and Integration Impact

- Remote APIs: `GET /users/me/progress`; `GET /categories` (existing).

## Acceptance Criteria

- AC-001: The repository maps progress JSON to a plain model.
- AC-002: The progress view model moves loading → loaded, loading → empty
  (no attempts), loading → error; `load()` recovers.
- AC-003: The card shows accuracy %, quizzes completed and points; Resume
  fires its callback.
- AC-004: The card shows empty and error-with-Retry states; Home still
  renders.
- AC-005: The Ask Nyaya card shows "Soon" and a coming-soon message on tap.
- AC-006: Recommended shows category names and quiz counts; tapping one
  reports it.
- AC-007: "View All" opens the grid with every category.
- AC-008: Recommended shows loading, empty and error-with-Retry states.
- AC-009: New strings are localized (e.g. Hindi).
- AC-010: Ask Nyaya and recommended cards are labelled buttons for screen
  readers; recommended cards fit a small phone with large text.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/home/data/progress_repository_test.dart` |
| AC-002 | Unit | `test/features/home/presentation/learning_progress_view_model_test.dart` |
| AC-003–AC-006, AC-008–AC-010 | Widget | `test/features/home/presentation/home_progress_recommended_test.dart` |
| AC-007 | Widget | `test/features/home/presentation/recommended_page_test.dart`, `test/app/main_shell_test.dart` |
| NFR-001 | Unit | `test/features/categories/presentation/categories_view_model_test.dart` |

## Open Questions

- Should Resume open the last attempted quiz once attempts are tracked?
- Should the backend offer real recommendations?
