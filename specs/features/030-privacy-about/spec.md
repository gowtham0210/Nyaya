# 030-privacy-about Privacy & Security, Log Out Everywhere, About

Status: Implemented
Last Updated: 2026-09-29
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`,
`../../adr/0004-platform-plugins.md`
Source: GitHub issue #37 (parent #24). Ported from `nisha-frontend`
(`privacy_security_screen`, `about_nyaya_screen`), without change-password.

## Problem

Learners can't see where they're signed in, end every session if a phone
is lost, or see what the app is and its version.

## Goals

- Profile → Privacy & security: active session count and "Log out from all
  devices" with confirmation.
- Profile → About Nyaya: purpose, features and version.

## Non-Goals

- Change password (accounts use phone + OTP; the screen says so).
- A list of individual sessions (the backend returns a count).

## Assumptions

- `GET /users/me/security` → `{ activeSessions }`.
- `POST /users/me/logout-all` ends every session, including this one.
- Version comes from `package_info_plus` (ADR 0004).

## Functional Requirements

- FR-001: Privacy shall show the active session count, with a spinner while
  loading and Retry on failure.
- FR-002: "Log out from all devices" shall ask for confirmation; Cancel
  does nothing.
- FR-003: Confirming shall call the backend, then end the session like
  logout (spec 021) and return to sign-in.
- FR-004: If the call fails, the learner stays signed in and sees the
  localized reason.
- FR-005: Privacy shall say there's no password to change.
- FR-006: About shall show the app name, tagline, description, features
  and "Version x.y.z (build)".

## Acceptance Criteria

- AC-001: The repository reads the count and posts logout-all.
- AC-002: The view model loads the count and reports logout success or
  error.
- AC-003: The Privacy page covers FR-001–FR-005.
- AC-004: About shows the injected version.
- AC-005: From Profile, logging out everywhere returns to sign-in with the
  session cleared; About shows the version (shell).
- AC-006: Strings are localized (e.g. Hindi).

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/settings/data/security_repository_test.dart` |
| AC-002 | Unit | `test/features/settings/presentation/privacy_view_model_test.dart` |
| AC-003, AC-006 | Widget | `test/features/settings/presentation/privacy_page_test.dart` |
| AC-004, AC-006 | Widget | `test/features/settings/presentation/about_page_test.dart` |
| AC-005 | Widget | `test/app/main_shell_test.dart` |
