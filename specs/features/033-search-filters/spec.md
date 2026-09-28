# 033-search-filters Search and Filters

Status: Implemented
Last Updated: 2026-09-29
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Source: GitHub issue #40 (parent #24). Ported from `nisha-frontend`
(`nyaya_search_bar`, `filter_sheet`, `filter_results_screen`), simplified:
Nisha matched hand-written keyword lists per category.

## Problem

Learners can't find a topic, article or update without browsing each tab.

## Goals

- A search bar on Home opens search.
- Typing searches quiz topics (backend categories), articles and legal
  updates at once.
- A filter sheet narrows by content type and by real backend categories;
  one tap clears all filters.

## Non-Goals

- Server-side search (no search endpoint); this searches what the app has
  loaded.
- Opening a category's quizzes (no category screen yet; shows coming soon).

## Assumptions

- Categories, articles and legal updates come from the shell's existing
  view models, so opening search fetches nothing new if the tabs loaded.
- Articles and updates carry no category id, so a picked category matches
  them when their text contains one of its key words as a whole word
  (words of 3+ characters in any script, minus "law", "laws", "act",
  "acts", "and", "the", "of"; e.g. "criminal" for "Criminal Law", "tax"
  for "Tax Law"). A label with no such word matches as a whole phrase.

## Functional Requirements

- FR-001: Home shall show a search bar that opens the search screen.
- FR-002: Search shall show all items grouped (Quiz topics, Articles,
  Legal Updates) and narrow them as the learner types (case-insensitive,
  names, titles and descriptions).
- FR-003: The filter sheet shall list the three content types and the
  backend categories; Apply narrows results; Clear all resets the sheet;
  closing without Apply changes nothing.
- FR-004: With filters on, the screen shall show how many and a one-tap
  "Clear filters".
- FR-005: No match shall show an empty state; a failed source shows the
  shared failure message with Retry, which reloads only what failed.
- FR-006: Tapping an article opens its detail (numbered as in the Articles
  tab); tapping a quiz topic shows a coming-soon message.
- FR-007: Filters stay disabled until the categories load; the Filters
  button and Home's search bar are labelled buttons.

## Acceptance Criteria

- AC-001: The pure `search` function matches text, content types and
  categories, and a query counts and clears its filters.
- AC-002: The view model loads all sources (sharing loaded data), exposes
  status and results, applies and clears filters, and retries failures.
- AC-003: The page covers FR-002–FR-006.
- AC-004: From Home, searching "equality" and tapping the article opens
  its detail (shell).
- AC-005: Strings are localized (e.g. Hindi).

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/search/domain/search_test.dart` |
| AC-002 | Unit | `test/features/search/presentation/search_view_model_test.dart` |
| AC-003, AC-005 | Widget | `test/features/search/presentation/search_page_test.dart` |
| AC-004 | Widget | `test/app/main_shell_test.dart` |
