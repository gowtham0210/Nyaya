# 013-categories Categories Screen

Status: Implemented (data source superseded by 017)
Last Updated: 2026-09-28
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`
Source: Home's "Categories" bottom-nav tab and "View All" action, both placeholders until now.

## Problem

Home shows only five categories in a horizontal strip and a "View All" action that does nothing; the Categories bottom-nav tab shows a "coming soon" snackbar. Learners have no way to browse the full set of law categories.

## Goals

- A main-tab screen (bottom nav present) listing every law category as a grid, in the established Nyaya visual language.
- Reachable from Home's "View All" action and from the Categories nav tab.
- Each card shows the category icon, label, and topic count.
- Search field to filter categories by name.

## Non-Goals

- Category → topic list screen (tapping a category reports intent via callback only, same pattern as Topic Detail's quiz taps); wiring to Topic Detail.
- Leaderboard, Bookmarks, Profile screens.
- Remote data (added by spec 017; data, quiz counts and load states live there).

## Actors

- Learner browsing categories from Home or the bottom nav.

## Assumptions

- Category list extends Home's 5 sample categories with additional law categories to demonstrate a real grid (not just 5 items).
- New-code-first naming, consistent with Topic Detail's taxonomy decision.

## Functional Requirements

- FR-001 Navy serif header "Categories" with supporting copy. The bottom nav is owned by the tab shell (spec 016).
- FR-002 Search field filters the grid by category label, case-insensitive, live as-you-type.
- FR-003 Two-column grid of category cards: icon tile, label, count meta line ("N quizzes" since spec 017).
- FR-004 Tapping a card reports the category id via callback.
- FR-005 Empty state when search matches no category.
- FR-006 Removed: tab switching moved to the tab shell (spec 016).

## Non-Functional Requirements

- Reuses shared `NyayaBottomNavBar`/`NyayaIcon` (extracted from Home in this change) and core color constants.
- Injectable plain view model per the established feature pattern.

## Data and Integration Impact

- See spec 017 for the backend source. `onCategorySelected` is the integration surface.

## Acceptance Criteria

- AC-001 Header renders.
- AC-002 Grid renders one card per category with correct label and count (spec 017 AC-004).
- AC-003 Typing in search filters the grid to matching categories only.
- AC-004 Search with no matches shows the empty state.
- AC-005 Tapping a card reports its id.
- AC-006 Removed; covered by spec 016.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001–AC-005 | Widget | `test/features/categories/presentation/categories_page_test.dart` (tests tagged with 013 IDs) |
| Data shape | Unit | `test/features/categories/presentation/categories_view_model_test.dart` |

## Open Questions

- Category → topic list screen and its wiring into Topic Detail (tracked as future work, same as Topic Detail's own non-goals).
