# 027-edit-profile Edit Profile and Photo

Status: Implemented
Last Updated: 2026-09-29
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Source: GitHub issue #34 (parent #24). Ported from `nisha-frontend`
(`edit_profile_screen`, `profile_api_service`). Extends `../021-profile/spec.md`.

## Problem

Learners can't fix their name or profession, or add a photo.

## Goals

- Edit name and profession from Profile and save.
- Change the photo from the camera or gallery; it uploads and shows on
  Profile.

## Non-Goals

- Editing phone (it's the sign-in identity; shown read-only).
- Email, language and reminders (Nisha put these here; they are separate
  issues).

## Assumptions

- `PATCH /users/me` takes `{ fullName, profession }` and returns the user.
- `POST /users/me/avatar` takes multipart field `avatar` and returns the
  user with `avatarUrl`.
- Professions are the sign-up list (`Profession`), stored as English values.

## Functional Requirements

- FR-001: The edit screen shall pre-fill name, profession and (read-only)
  phone.
- FR-002: Save shall validate the name like sign-up (required, 3+ chars),
  send the changes, close the screen and say "Profile updated".
- FR-003: "Change photo" shall offer camera or gallery; a picked photo
  uploads and shows at once; cancelling does nothing.
- FR-004: A failed save or upload shall show the localized failure message
  and keep the learner's edits.
- FR-005: After any successful change, Profile reloads.

## Acceptance Criteria

- AC-001: The repository PATCHes name and profession and posts the photo as
  multipart `avatar` (through the fake `http.Client`).
- AC-002: The view model saves/uploads, exposes busy and error, keeps the
  old profile on failure, and reports each change.
- AC-003: The page pre-fills, validates, saves and closes with a message.
- AC-004: A failed save shows the error and keeps the edits.
- AC-005: A gallery photo uploads; a cancelled pick uploads nothing.
- AC-006: Strings are localized (e.g. Hindi).

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/profile/data/edit_profile_repository_test.dart` |
| AC-002 | Unit | `test/features/profile/presentation/edit_profile_view_model_test.dart` |
| AC-003–AC-006 | Widget | `test/features/profile/presentation/edit_profile_page_test.dart` |
| Open from Profile | Widget | `test/app/main_shell_test.dart` |

## Open Questions

- Does the backend accept `profession` on `PATCH /users/me`?
- Max upload size and accepted image types?
