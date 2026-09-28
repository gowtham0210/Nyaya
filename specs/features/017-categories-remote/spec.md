# 017-categories-remote Categories from the Backend

Status: Implemented
Last Updated: 2026-09-28
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Source: GitHub issue #26 (parent #24). Extends `../013-categories/spec.md`.

## Problem

The Categories grid shows hard-coded sample categories, so learners see
topics the app may not have and miss ones it does.

## Goals

- The grid shows the backend's active categories in the learner's language.
- Loading, empty and error states are clear, with Retry.
- A shared load-state pattern and widget that later data screens reuse.

## Non-Goals

- Category → quiz list screen (tapping still reports the category).
- Home's category strip (stays sample data until the Home tickets).
- Reloading when the language changes (done in spec 028, issue #35).

## Actors

- Learner browsing categories.

## Assumptions

- `GET /categories` returns `{ items: Category[] }` with `id`, `name`,
  `slug`, `description`, `imageUrl`, `isActive`, and requires a bearer token.
- `GET /categories/:id/quizzes` returns `{ items: Quiz[] }`; its length is the
  category's quiz count (same approach as `nisha-frontend`).
- The backend has no icon or colour per category; the app picks them from the
  slug, falling back to a fixed palette.

## Functional Requirements

- FR-001: When the Categories tab opens, the app shall load active categories
  from the backend and show a loading indicator meanwhile.
- FR-002: When categories load, the grid shall show one card per category
  with its name and quiz count.
- FR-003: When a quiz count can't be loaded, the card shall show no count
  rather than hide the category.
- FR-004: When the backend returns no active categories, the app shall show
  an empty state.
- FR-005: When loading fails, the app shall show a localized message for the
  failure type (offline, session ended, other). Offline and other failures
  shall offer a Retry button that reloads; a session-ended failure shall not,
  since the app is already returning to sign-in (spec 016).
- FR-006: When the learner types in search, the app shall filter loaded
  categories by name, case-insensitively.
- FR-007: When an earlier load finishes after a later one, the app shall keep
  the later result.
- FR-008: When the backend response can't be read, the app shall show the
  error state rather than keep loading.

## Non-Functional Requirements

- NFR-001: Quiz counts load in parallel.
- NFR-002: The load-state type and widget live in core and carry no
  categories-specific code.

## UX Notes

- Empty and error states reuse the shared state widget: icon, message,
  optional Retry.
- Count label is pluralised per language.

## Data and Integration Impact

- Remote APIs: `GET /categories`, `GET /categories/:id/quizzes`, with `lang`.

## Acceptance Criteria

- AC-001: The repository maps active backend categories and their quiz counts
  to plain models, skipping inactive ones.
- AC-002: A failed quiz count yields a category with no count.
- AC-003: The view model moves loading → loaded, loading → empty, and
  loading → error (including an unreadable response); `load()` again
  recovers from error; the latest overlapping load wins.
- AC-004: The grid shows each loaded category's name and "N quizzes".
- AC-005: Search filters the loaded grid; no match shows the search empty
  state.
- AC-006: An offline failure shows the localized offline message and Retry;
  tapping Retry loads the categories. A server error shows the generic
  message with Retry; an ended session shows its message without Retry.
- AC-007: No categories shows the empty state.
- AC-008: The shared state widget renders loading, empty, error (with Retry)
  and loaded content.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001, AC-002 | Unit | `test/features/categories/data/categories_repository_test.dart` |
| AC-003 | Unit | `test/features/categories/presentation/categories_view_model_test.dart` |
| AC-004–AC-007 | Widget | `test/features/categories/presentation/categories_page_test.dart` |
| AC-008 | Widget | `test/core/presentation/widgets/load_state_view_test.dart` |

## Open Questions

- Could `GET /categories` include a quiz count, to avoid one request per
  category?
- Should cards show the backend's `imageUrl` instead of an icon?
