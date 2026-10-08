# 035-hide-unbuilt-entry-points Hide Unbuilt Entry Points

Status: Implemented
Last Updated: 2026-10-05
Owner: Gowtham
Related ADRs: —
Source: UI/UX audit `docs/ui-audit/ui-ux-audit.md` §3.6 (priority 2).

## Problem

Many taps answer "coming soon" or do nothing. Some of these controls only
exist to say "not yet": the bell (with an always-on unread dot), the Ask
Nyaya card, the Categories filter button, sample Popular Quizzes and the
Review answers button. They make the app feel unfinished.

## Goals

- A control for an unbuilt feature is hidden, not stubbed.
- Each comes back by wiring its callback; no other code change needed.

## Non-Goals

- The Leaderboard tab stays (owner decision 2026-10-05: keep 5 tabs).
- Category taps keep their coming-soon message (owner decision
  2026-10-05) until category screens exist.
- Building any of the hidden features.

## Functional Requirements

- FR-001: While Home has no notifications handler, it shall hide the bell
  and its unread dot.
- FR-002: While Home has no Ask Nyaya handler, it shall hide the Ask Nyaya
  card.
- FR-003: While Home has no quiz handler, it shall hide the Popular Quizzes
  section (its cards are sample data).
- FR-004: While Categories has no filters handler, it shall hide the
  Filters button; the search field takes the full width.
- FR-005: While the result screen has no review handler, it shall hide
  Review answers and show Back to topic as the only, primary button.
- FR-006: When a handler is given, each control shall show and report taps
  as before.

## Acceptance Criteria

- AC-001: Unwired Home hides the bell, badge, Ask Nyaya and Popular
  Quizzes; wired Home shows them and reports taps.
- AC-002: Unwired Categories hides Filters; wired shows it and reports taps.
- AC-003: Without review, Back to topic is the only button and is filled.
- AC-004: The app shell wires none of these, so none show in the app.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Widget | `test/features/home/presentation/home_page_test.dart`, `home_progress_recommended_test.dart` |
| AC-002 | Widget | `test/features/categories/presentation/categories_page_test.dart` |
| AC-003 | Widget | `test/features/quiz_result/presentation/quiz_result_page_test.dart` |
| AC-004 | Manual | iOS simulator; screenshots in `docs/ui-audit/after-035/` |
