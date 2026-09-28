# 016-bottom-nav-shell Bottom Tab Shell

Status: Implemented
Last Updated: 2026-09-28
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Source: GitHub issue #25 (parent #24).

## Problem

Each main screen draws its own bottom nav and pushes a new page per tab, so
tabs lose their state, back behaves oddly, and three tabs are "coming soon"
snackbars. The Profile tab is a hidden logout button. There is no path back
to sign-in when the backend session dies.

## Goals

- One shell with five tabs: Home, Categories, Leaderboard, Articles, Profile.
- Each tab keeps its state when switching.
- Clear placeholders for tabs not built yet.
- Expired sessions return the learner to sign-in with a message.

## Non-Goals

- Real Leaderboard, Articles and Profile screens (tickets #32, #33).
- Nested navigators per tab; full-screen flows push on the root navigator.

## Actors

- Signed-in learner.

## Assumptions

- Tab pages push full-screen flows on the root navigator; no tab needs its
  own navigation stack yet.
- Keeping every tab mounted is cheap enough for five tabs.

## Functional Requirements

- FR-001: After onboarding, the app shall show the tab shell with five tabs
  and localized labels, Home active.
- FR-002: When the learner taps a tab, the shell shall show it and mark it
  active, keeping every tab's state.
- FR-003: When "View all categories" is tapped on Home, the shell shall
  switch to the Categories tab.
- FR-004: When back is pressed on any tab other than Home, the shell shall
  switch to Home instead of leaving the app.
- FR-005: Leaderboard, Articles and Profile shall show a localized
  "coming soon" state until built.
- FR-006: When the API client reports the session expired, the app shall
  revoke the backend session and sign out of Firebase (best-effort), clear
  the local session, return to sign-in as the only route and show a message.
- FR-007: The shell shall be the only owner of the bottom nav; Home and
  Categories shall not draw their own, and the app shall offer no Bookmarks
  tab and no Profile-tab logout.
- FR-008: After goal selection, the shell shall be the only route, so back
  on Home leaves the app.

## Non-Functional Requirements

- NFR-001: Repeated expiry signals from parallel requests shall end the
  session once.
- NFR-002: Ending the session shall not depend on Firebase sign-out
  succeeding.

## UX Notes

- Bottom nav is the shared `NyayaBottomNavBar`.
- Topic detail, quiz and results open full-screen over the shell.

## Data and Integration Impact

- Remote APIs: none new. Listens to `AppServices.sessionExpired`.

## Acceptance Criteria

- AC-001: Five tabs render with labels; Home is active and shown.
- AC-002: Tapping a tab shows it and marks it active.
- AC-003: A tab's state survives switching away and back.
- AC-004: The shell controller can switch tabs (used by "View all").
- AC-005: Back on a non-Home tab returns to Home.
- AC-006: Placeholder tabs show a localized "coming soon" state.
- AC-007: A session-expired signal triggers the expiry handler once.
- AC-008: "View all categories" on Home switches to Categories.
- AC-009: Ending the session lands on sign-in as the only route with the
  message shown.
- AC-010: Expiry signals that arrive while one is being handled are ignored.
- AC-011: After goal selection the shell cannot pop.

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-002–AC-005 | Widget | `test/features/shell/presentation/tab_shell_page_test.dart` |
| AC-006 | Widget | `test/features/shell/presentation/coming_soon_tab_test.dart` |
| AC-007, AC-010 | Widget | `test/app/session_expiry_listener_test.dart` |
| AC-009 | Widget | `test/app/session_actions_test.dart` |
| AC-011 | Widget | `test/app/post_sign_up_flow_test.dart` |
| AC-001, AC-008 | Widget | `test/app/main_shell_test.dart` |

## Open Questions

- Tokens are in memory only, so after an app restart the first backend call
  expires the session and returns the learner to sign-in. Persisting tokens
  is out of scope (issue #24).
