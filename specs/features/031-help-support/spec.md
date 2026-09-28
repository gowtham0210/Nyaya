# 031-help-support Help & Support Requests

Status: Implemented
Last Updated: 2026-09-29
Owner: Gowtham
Related ADRs: `../../adr/0002-data-layer.md`, `../../adr/0003-localization.md`
Source: GitHub issue #38 (parent #24). Ported from `nisha-frontend`
(`help_support_screen`, `support_request`, `profile_api_service`).

## Problem

Learners can't reach the Nyaya team from the app.

## Goals

- Profile → Help & support: write a subject and message and send it.
- See past requests with status and date.

## Non-Goals

- Nisha's FAQ list (not in the issue).
- Replies or threads on a request.

## Assumptions

- `GET /users/me/support-requests` → `{ items: [{ id, subject, message,
  status, createdAt }] }`; `POST` the same path with `{ subject, message }`
  returns the new request (maybe without `createdAt`).
- Status is `open`, `in_progress`, `resolved` or `closed`; anything else
  shows as open.

## Functional Requirements

- FR-001: The form shall require a subject and a message of 10+ characters.
- FR-002: Send shall post the request, confirm with "Your request has been
  sent.", clear the form and refresh the list.
- FR-003: A failed send shall keep the text and show the localized reason.
- FR-004: Past requests shall show newest first, each with subject,
  message, a localized status and a localized date.
- FR-005: The list shall show loading, empty and error-with-Retry states.

## Acceptance Criteria

- AC-001: The repository lists (newest first, statuses mapped) and sends.
- AC-002: The view model loads, sends (trimmed) and exposes send errors.
- AC-003: The page validates, sends, confirms and clears; a failure keeps
  the text.
- AC-004: The page lists requests with status and date, or the empty state.
- AC-005: Profile → Help & support shows past requests (shell).
- AC-006: Strings are localized (e.g. Hindi).

## Test Traceability

| Criterion | Test Layer | Planned Test |
| --- | --- | --- |
| AC-001 | Unit | `test/features/help/data/support_repository_test.dart` |
| AC-002 | Unit | `test/features/help/presentation/support_view_model_test.dart` |
| AC-003, AC-004, AC-006 | Widget | `test/features/help/presentation/help_support_page_test.dart` |
| AC-005 | Widget | `test/app/main_shell_test.dart` |
