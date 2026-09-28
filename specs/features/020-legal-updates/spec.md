# 020-legal-updates Legal Updates on Home and See-All List

Status: Implemented
Last Updated: 2026-09-28
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Source: GitHub issue #30 (parent #24). Ported from `nisha-frontend` 5574bfe
(`legal_updates_section`, `legal_update`, `legal_updates_repository`).

## Problem

Learners can't see recent law changes in the app.

## Goals

- Home shows the latest legal updates with category, date and source.
- "See all" opens a full list of updates.
- Both handle loading, empty and error-with-Retry states.

## Non-Goals

- Update detail screen (cards aren't tappable yet).
- Category filter chips (Nisha had them on the Articles tab).
- Bookmarking updates.
- Reloading when the language changes (done in spec 028, issue #35).

## Actors

- Learner on Home.

## Assumptions

- `GET /legal-updates` returns `{ items: LegalUpdate[] }` with `id`,
  `category`, `title`, `summary`, `updateDate`, `source`, `imageUrl`, and
  requires a bearer token. No paging.
- `category` is an English value (Judgements, Legislation, Reforms, Notices);
  the app shows a translated label for known ones (also the spelling
  `Judgments`) and the raw value otherwise.

## Functional Requirements

- FR-001: When Home opens, the app shall load legal updates from the backend
  and show a loading indicator in the section meanwhile.
- FR-002: The Home section shall show the 3 newest updates, newest first.
- FR-003: Each update shall show its category, title, summary, date in the
  learner's locale format, and source when present.
- FR-004: When the learner taps "See all", the app shall open a list of all
  updates, newest first, that scrolls.
- FR-005: When there are no updates, both surfaces shall show an empty state.
- FR-006: When loading fails, both surfaces shall show the shared localized
  failure message with Retry (spec 017 FR-005); Retry reloads.
- FR-007: A section failure shall not block the rest of Home.
- FR-008: When overlapping loads finish out of order, the latest wins.

## Non-Functional Requirements

- NFR-001: Home and the see-all list share one view model, so opening the
  list doesn't reload.
- NFR-002: An unparseable date shows as sent; the card still renders.

## UX Notes

- Section sits last on Home; header matches Home's other sections, with
  "View All".
- Card: category pill, title (2 lines), summary (2 lines), date · source.

## Data and Integration Impact

- Remote APIs: `GET /legal-updates`, with `lang`.

## Acceptance Criteria

- AC-001: The repository maps backend updates to plain models, newest first;
  a missing source is null.
- AC-002: The view model moves loading → loaded, loading → empty, and
  loading → error; `load()` again recovers; the latest overlapping load wins.
- AC-003: Home shows the 3 newest updates with category, localized date and
  source.
- AC-004: Home's section shows loading, empty and error-with-Retry states,
  and the rest of Home still renders.
- AC-005: "See all" opens the list, which shows every update and scrolls.
- AC-006: The list shows loading, empty and error-with-Retry states; Retry
  reloads. Cards fit a small phone with large text.
- AC-007: Known categories and dates are localized (e.g. Hindi).

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/legal_updates/data/legal_updates_repository_test.dart` |
| AC-002 | Unit | `test/features/legal_updates/presentation/legal_updates_view_model_test.dart` |
| AC-003, AC-004, AC-007 | Widget | `test/features/legal_updates/presentation/legal_updates_section_test.dart` |
| AC-005, AC-006 | Widget | `test/features/legal_updates/presentation/legal_updates_page_test.dart` |
| AC-005 (open/back) | Widget | `test/app/main_shell_test.dart` |

## Open Questions

- Should the backend sort and page updates, or send a `limit` for Home?
- Should cards open a detail screen or the source link?
