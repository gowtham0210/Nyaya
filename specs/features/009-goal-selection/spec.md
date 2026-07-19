# 009-goal-selection Goal Selection Screen

Status: Implemented
Last Updated: 2026-07-19
Owner:
Related ADRs: `../../adr/0001-adopt-spec-driven-development.md`
Source: GitHub issue #20 (Spec: Goal selection screen (Phase 3)); wayfinder decisions on issues #5 and #9.

## Problem

After signing up, a new user lands on a generic home experience that knows nothing about why they came. A citizen, an exam aspirant, and an LLB student all see the same content, so the "goal as lens" model has no way to take effect.

## Goals

- Show a one-time goal-selection screen between sign-up and home.
- Offer exactly three intent goals: Learn law for life (default), Crack an exam, Study law.
- Carry the chosen goal forward in memory so later surfaces can render through that lens.
- Match the approved Phase 3 mockup (`mockups/`, Jul 18 2026 10:52 PM image).

## Non-Goals

- Persisting the goal or skip-on-relaunch behavior.
- Applying the goal lens on home or topics.
- Goal editing from Profile/Settings (Phase 14).
- Exam-track selection (removed from v1).
- Localization.

## Actors

- Newly signed-up user choosing why they came to Nyaya.

## Assumptions

- No backend or local persistence exists yet; the goal lives in memory (`GoalSession`).
- Goal ids are the ubiquitous language: `learn-law-for-life`, `crack-an-exam`, `study-law`.

## Functional Requirements

- FR-001 Serif two-line heading: "What brings you" (navy) / "to Nyaya?" (gold), with helper line "Choose your goal — you can change it anytime."
- FR-002 Three selectable cards, each with icon tile, bold navy title, one-line grey description, and a radio indicator.
- FR-003 "Learn law for life" pre-selected; exactly one goal selectable at a time; tapping a card moves the selection.
- FR-004 Selected card shows gold border, tinted fill, and filled gold radio with white check.
- FR-005 Gold CONTINUE pill reports the selected goal id and navigates to home.
- FR-006 Footnote "You can switch goals later in Profile."
- FR-007 Back arrow (standard pop) top-left; 4-segment progress indicator (last active) top-right.
- FR-008 Ivory background with dot-grid, sparkle, temple watermark, and bottom wave ornaments.
- FR-009 Content scrolls when vertical space runs out.
- FR-010 Cards expose mutually exclusive selection semantics for screen readers.

## Non-Functional Requirements

- Reuse shared Nyaya widget/ornament library and color constants.
- Follow the page + view-model feature pattern; view model injectable for tests.

## UX Notes

- Flow wiring lives at the app-shell level (`lib/app/post_sign_up_flow.dart`): sign-up success → goal selection → home, each via route replacement.
- Icons are themed icon tiles (scales, trophy, graduation cap), not raster assets.

## Data and Integration Impact

- `GoalSession.selectedGoalId` holds the choice in memory until persistence exists.

## Acceptance Criteria

- AC-001 Heading, helper line, three cards with exact copy, CONTINUE, and footnote render.
- AC-002 Default selection is "Learn law for life"; tapping another card moves the selection.
- AC-003 CONTINUE invokes the continue callback with the currently selected goal id.
- AC-004 Back arrow, progress indicator, temple, and sparkle ornaments are present.
- AC-005 Selected card exposes selected + mutually-exclusive semantics.
- AC-006 An injected view model drives the initial selection.

## Test Traceability

- `test/features/goal_selection/presentation/goal_selection_view_model_test.dart` — goals, default, selection change, invalid-id guard.
- `test/features/goal_selection/presentation/goal_selection_page_test.dart` — AC-001 through AC-006.
- `test/features/auth/presentation/sign_up_page_test.dart` — valid sign-up submission invokes `onSignUpCompleted`.

## Open Questions

- Golden test deferred until the splash golden baseline is fixed.
- Where home consumes `GoalSession.selectedGoalId` is decided by the home-lens feature.
