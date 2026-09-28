# 021-profile Profile Tab

Status: Implemented
Last Updated: 2026-09-29
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Source: GitHub issue #33 (parent #24). Ported from `nisha-frontend`
(`profile_screen`, `initials_avatar`, `profile_api_service`, `logout_screen`).

## Problem

The Profile tab is a placeholder, so learners can't see who they're signed
in as, their progress, or log out.

## Goals

- Profile shows name, photo (or initials), profession and four stats.
- It lists entries for Edit profile, Language, Daily reminders, Privacy &
  security, Help & support, Legal help resources and About.
- Logout asks first, then ends the session and returns to sign-in.

## Non-Goals

- The screens behind each entry (issues #34–#39); until wired, an entry
  shows a coming-soon message.

## Assumptions

- `GET /users/me` → `fullName`, `phone`, `profession?`, `avatarUrl?`
  (relative to the API origin or absolute).
- `GET /users/me/progress` → `totalQuizzesCompleted`, `totalPoints`;
  `GET /users/me/streak` → `currentStreak`;
  `GET /users/me/categories-explored` → `categoriesExplored`.
- Logout reuses `endSession` (spec 016): backend revoke, Firebase sign-out,
  local session cleared, back to sign-in.

## Functional Requirements

- FR-001: When the Profile tab opens, the app shall load the profile and
  stats together, with a loading indicator.
- FR-002: The header shall show the photo, or the name's initials when
  there is no photo or it fails to load.
- FR-003: Stats shall show day streak, categories explored, quizzes
  completed and points.
- FR-004: Each entry shall report its tap; unwired entries show a
  coming-soon message.
- FR-005: Log out shall ask for confirmation; Cancel keeps the learner
  signed in; confirming ends the session.
- FR-006: A failure shows the shared failure message with Retry.

## Acceptance Criteria

- AC-001: The repository maps profile and stats JSON, loading all four
  endpoints together; an absent photo is null.
- AC-002: The view model moves loading → loaded / error; `load()` recovers.
- AC-003: The page shows name, profession, initials and the four stats.
- AC-004: Entries report their taps.
- AC-005: Log out shows a confirmation; Cancel does nothing; Log out calls
  back.
- AC-006: The error state shows Retry, which reloads.
- AC-007: Strings are localized (e.g. Hindi).

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/profile/data/profile_repository_test.dart` |
| AC-002 | Unit | `test/features/profile/presentation/profile_view_model_test.dart` |
| AC-003–AC-007 | Widget | `test/features/profile/presentation/profile_page_test.dart` |
| FR-005 end to end | Widget | `test/app/main_shell_test.dart` |

## Open Questions

- Does `/users/me` return `profession` and `avatarUrl` on the current backend?
